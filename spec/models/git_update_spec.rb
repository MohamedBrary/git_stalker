require 'rails_helper'

RSpec.describe GitUpdate, type: :model do
  before(:each) { @git_update = GitUpdate.new }

  subject { @git_update }

  it { should respond_to(:user) }
  it { should respond_to(:repository) }
end
