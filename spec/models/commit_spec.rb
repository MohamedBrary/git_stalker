require 'rails_helper'

RSpec.describe Commit, type: :model do

  before(:all) {
    @committer = User.create(email: 'committer@git.com')
    @pusher = User.create(email: 'pusher@git.com')
    @commit = Commit.new(pusher: @pusher, committer: @committer)
  }

  subject { @commit }

  it { should respond_to(:committer) }
  it "#committer returns a user" do
    expect(@commit.committer.id).to match @committer.id
  end

  it { should respond_to(:pusher) }
  it "#pusher returns a user" do
    expect(@commit.pusher.id).to match @pusher.id
  end

end
