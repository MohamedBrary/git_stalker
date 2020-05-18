require 'rails_helper'

RSpec.describe Release, type: :model do
  before(:each) { @release = Release.new }

  subject { @release }

  it { should respond_to(:releaser) }
  it { should respond_to(:commits) }
end
