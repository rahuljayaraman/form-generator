require 'spec_helper'

describe Role do
  it { should have_fields :role_name, :role_description }
  it { should have_and_belong_to_many :forms }
  it { should have_and_belong_to_many :reports }
  it { should have_and_belong_to_many :users }
  it { should belong_to :application }
  it { should validate_presence_of :role_name }

  let(:application) { Application.new application_name: "test" }
  let(:role) { application.roles.new role_name: "test_role" }
  let(:user) { Fabricate :standalone_user }

  it "should accomodate application specific users" do
    application.save
    role.users << user
    role.save
    role.users.should include user
    user.app_roles(application.id).should include role
  end
end
