require 'spec_helper'

describe Report do
  it { should have_fields(:report_name) }
  it { should validate_presence_of(:report_name) }
  it { have_and_belong_to_many(:source_attributes) }
  it { should belong_to(:user) }
end
