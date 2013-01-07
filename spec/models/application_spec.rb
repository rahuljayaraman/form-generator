require 'spec_helper'

describe Application do
  it { should have_fields(:application_name, :application_description) }
  it { should validate_presence_of :application_name }
  it { should belong_to :owner }

  it "should set the creator of the application as the owner" do
    user = Fabricate.build :standalone_user
    application = user.owned_applications.new application_name: "test"
    application.owner.should == user
    user.owned_applications.should include application
  end

  it "should allow adding users as members" do
    user = Fabricate.build :standalone_user
    application = user.owned_applications.new application_name: "test"
    member = Fabricate.build :standalone_user, email: "test@test.com"
    application.members << member
    application.members.should include member
    application.save
    member.used_applications.should include application
  end
end
