require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'database_cleaner/active_record'
DatabaseCleaner.strategy = :truncation

resource 'GitUpdates' do
  explanation 'GitUpdate resource'

  # header 'Content-Type', 'application/json'

  post '/git_updates' do

    path = File.join(Rails.root, 'spec', 'fixtures', 'payloads')
    payloads = ['pull_request_action', 'push_payload', 'release_payload']
    payloads.each do |payload|
      # because we check on number of records created after each call
      DatabaseCleaner.clean
      payload_json = JSON.parse(File.open(File.join(path, "#{payload}.json")).read)
      expected_records = payload_json.delete('expected_records')

      context '200' do
        # TODO hopefully this gem is smart enough to extract the parameters and add it to docs
        # because I am not writing all that now :'D
        payload_json.each do |param_name, param_value|
          param_desc = "#{param_name.titleize}, as a #{param_value.class}, for example: #{JSON.pretty_generate(param_value)}"
          parameter param_name, param_desc, required: true
        end

        example "Recieveing a #{payload.titleize.downcase}" do
          do_request(payload_json)

          expect(status).to eq(200)
          expected_records.each do |class_name, expected_number|
            klass = class_name.camelize.constantize
            expect(klass.count).to eq(expected_number), "expected #{expected_number} of #{klass}, got #{klass.count}"
          end
        end


        example "Recieveing a #{payload.titleize.downcase} for existing records dont create duplicates", document: false do
          # # call it once here, so in the request, records would already have existed
          Upsert::GitUpdate.run(ProcessPayload::GitUpdate.run(payload_json).result)
          do_request(payload_json)

          expect(status).to eq(200)
          expected_records['git_update'] = 2
          expected_records.each do |class_name, expected_number|
            klass = class_name.camelize.constantize
            expect(klass.count).to eq(expected_number), "expected #{expected_number} of #{klass}, got #{klass.count}"
          end
        end

      end # end of context
    end # of payloads iterations

  end
end
