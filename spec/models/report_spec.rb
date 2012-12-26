require 'spec_helper'

describe Report do
  it { should have_fields(:report_name) }
  it { should validate_presence_of(:report_name) }
  it { should have_many(:report_attributes) }
  it { should belong_to(:user) }
end
