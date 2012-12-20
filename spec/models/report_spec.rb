require 'spec_helper'

describe Report do
  it { should have_fields(:report_name) }
  it { should have_and_belong_to_many(:sources) }
  it { should validate_presence_of(:report_name) }
  it { should have_many(:report_parameters) }
end
