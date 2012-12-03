require 'spec_helper'

describe User do

  it { should have_fields(:email, :name) }

  context "Validations" do
    let(:user) { build(:user) }
    subject {user}

    its(:email) { should_not be_nil} 
    it { should validate_uniqueness_of(:email) }
    its(:password) { should == user.password_confirmation} 
  end
end
