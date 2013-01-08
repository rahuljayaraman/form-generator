require 'spec_helper'

describe Form do
  it { should have_fields :form_name }
  it { should validate_presence_of :form_name }
  it { should validate_uniqueness_of :form_name }
  it { should have_many :form_attributes }
  it { should have_and_belong_to_many :roles }
end
