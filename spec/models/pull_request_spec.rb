require 'rails_helper'

RSpec.describe PullRequest, type: :model do
  before(:each) { @pull_request = PullRequest.new(state: PullRequest::STATE_APPROVED) }

  subject { @pull_request }

  it { should respond_to(:commits) }
  it "#commits returns an AR relation" do
    expect(@pull_request.commits).to be_a_kind_of(ActiveRecord::Relation)
  end
end
