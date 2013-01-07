require 'spec_helper'

describe Application do
  it { should have_fields(:application_name, :application_description) }
  it { should validate_presence_of :application_name }
  it { should belong_to :owner }

  let(:user) { Fabricate.build :standalone_user }
  let(:application) { user.owned_applications.new application_name: "test" }

  it "should allow the owner to invite users to the application" do
    INVITED_MEMBERS = ["test@test.com", "test1@test.com"]
    user = stub(:user, id: "123")
    application.stub(:members) {[]}
    User.stub(:create_temporary_user) { user }
    user.stub(:send_activation_email)
    User.should_receive(:create_temporary_user).with(INVITED_MEMBERS[0])
    User.should_receive(:create_temporary_user).with(INVITED_MEMBERS[1])
    user.should_receive(:send_activation_email).with(application.id)
    application.add_members INVITED_MEMBERS
  end

  it "should set the creator of the application as the owner" do
    application.owner.should == user
    user.owned_applications.should include application
  end

  it "should allow adding users as members" do
    member = Fabricate.build :standalone_user, email: "test@test.com"
    application.members << member
    application.members.should include member
    application.save
    member.used_applications.should include application
  end
end
