require 'spec_helper'

describe User do

  it { should have_fields(:email, :name, :activation_state, :activation_token, :activation_token) }
  it { should have_many(:sources) }
  it { should have_many(:reports) }

  context "Validations" do
    let(:user) { Fabricate.build(:user) }
    subject {user}

    its(:email) { should_not be_nil} 
    it { should validate_uniqueness_of(:email) }
  end

  context "Invitations" do
    subject { User }

    it { should respond_to :create_temporary_user }

    it "should create temporary user" do
      email = "test@test.com"
      user = User.stub(:create) { stub :user, email: email, id: "123", activation_token: "123" }
      User.should_receive(:create).with({email: email})
      User.create_temporary_user email
    end
  end
end
