require 'rails_helper'
  require 'rspec_api_documentation/dsl'
  resource 'GitUpdates' do
    explanation 'GitUpdate resource'

    header 'Content-Type', 'application/json'

    post '/git_updates' do

      context '200' do
        path = File.join(Rails.root, 'spec', 'fixtures', 'payloads')
        payloads = ['pull_request_action', 'push_payload', 'release_payload']
        payloads.each do |payload|
          payload_json = JSON.parse(File.open(File.join(path, "#{payload}.json")).read)
          expected_records = payload_json.delete('expected_records')
          example_request "Recieveing a #{payload.titleize.downcase}" do
            # TODO hopefully this gem is smart enough to extract the parameters and add it to docs
            # because I am not writing all that now :'D
            do_request(payload_json)

            expect(status).to eq(200)
            expected_records.each do |class_name, expected_number|
              klass = class_name.camelize.constantize
              expect(klass.count).to eq(expected_number)
            end
          end
        end
      end

    end
  end
