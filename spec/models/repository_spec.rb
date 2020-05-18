require 'rails_helper'

RSpec.describe Repository, type: :model do
  before(:each) { @repository = Repository.new(name: 'test_repo') }

  subject { @repository }

  it { should respond_to(:name) }

  it "#name returns a string" do
    expect(@repository.name).to match 'test_repo'
  end
end
