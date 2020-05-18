require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) { @user = User.new(email: 'user@example.com') }

  subject { @user }

  it { should respond_to(:releases) }
  it "#releases returns an AR relation" do
    expect(@user.releases).to be_a_kind_of(ActiveRecord::Relation)
  end

  it { should respond_to(:authored_commits) }
  it "#authored_commits returns an AR relation" do
    expect(@user.authored_commits).to be_a_kind_of(ActiveRecord::Relation)
  end

  it { should respond_to(:created_pull_requests) }
  it "#created_pull_requests returns an AR relation" do
    expect(@user.created_pull_requests).to be_a_kind_of(ActiveRecord::Relation)
  end

  it { should respond_to(:email) }
  it "#email returns a string" do
    expect(@user.email).to match 'user@example.com'
  end
end
