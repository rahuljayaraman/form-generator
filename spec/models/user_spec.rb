require 'spec_helper'

describe User do

  it { should have_fields(:email, :name) }
  it { should have_many(:sources) }
  it { should have_many(:reports) }

  context "Validations" do
    let(:user) { Fabricate.build(:user) }
    subject {user}

    its(:email) { should_not be_nil} 
    it { should validate_uniqueness_of(:email) }
  end
end
