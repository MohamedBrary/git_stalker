require 'rails_helper'

RSpec.describe ProcessPayload::GitUpdate, type: :model do

  before(:all) {
    @committer = User.create(email: 'committer@git.com')
    @pusher = User.create(email: 'pusher@git.com')
    @commit = Commit.new(pusher: @pusher, committer: @committer)
  }

  subject { ProcessPayload::GitUpdate }
  path = File.join(Rails.root, 'spec', 'fixtures', 'payloads')
  payloads = ['pull_request_action', 'push_payload', 'release_payload']
  payloads.each do |payload|
    it "Should process #{payload.titleize.downcase} without errors" do
      payload_json = JSON.parse(File.open(File.join(path, "#{payload}.json")).read)
      payload_json.delete('expected_records')
      outcome = ProcessPayload::GitUpdate.run(payload_json)
      expect(outcome.success?).to be true
    end
  end

end
