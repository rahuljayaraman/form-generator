require 'spec_helper'

describe Role, focus: true do
  it { should have_fields :role_name, :role_description }
  it { should have_and_belong_to_many :forms }
  it { should have_and_belong_to_many :reports }
  it { should have_and_belong_to_many :users }
  it { should belong_to :application }
  it { should validate_presence_of :role_name }
end
