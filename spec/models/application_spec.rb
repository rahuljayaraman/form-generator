require 'spec_helper'

describe Application do
  it { should have_fields(:application_name, :application_description) }
  it { should validate_presence_of :application_name }
  it { should belong_to :owner }

  let(:user) { Fabricate.build :standalone_user }
  let(:application) { user.owned_applications.new application_name: "test" }

  it "should allow removal of user from the application without deleting him" do
    member = Fabricate :standalone_user, email: "test@test.com"
    application.members << member 
    application.save
    application.remove_member member.id
    application.save
    application.members.should_not include member
    User.find_by_id(member.id).should == member
  end

  it "should send users with pending registration the activation link" do
    user.activation_state = 'pending'
    application.stub(:send_activation_email)
    application.stub(:send_confirmation_email)
    application.should_receive(:send_activation_email).with(user)
    application.add_member user
  end

  it "should add registered members & register un-registered members" do
    user.save
    MEMBERS = [user.email, "test@test.com"]
    application.stub(:add_member)
    application.stub(:register_user)
    application.should_receive(:add_member).with(user)
    application.should_receive(:register_user).with(MEMBERS[1])
    application.register_or_add MEMBERS
  end

  it "should allow registration of unregistered members by email" do
    email = "test@test.com"
    application.stub(:send_activation_email)
    application.stub(:add_member)
    application.should_receive(:add_member)
    application.should_receive(:send_activation_email)
    unregistered_member = application.register_user email
    unregistered_member.should respond_to(:activation_token)
  end

  it "should allow adding users as members" do
    member = Fabricate.build :standalone_user, email: "test@test.com"
    application.stub(:send_confirmation_email)
    application.add_member member
    application.members.should include member
    application.save
    member.used_applications.should include application
  end

  it "should set the creator of the application as the owner" do
    application.owner.should == user
    user.owned_applications.should include application
  end
end
