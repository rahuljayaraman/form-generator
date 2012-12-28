require 'spec_helper'

describe ModelValidation do
  it { should be_embedded_in(:source_attribute) }
  it { should have_fields(:validation_type, :min, :max, :message) }

  it "should return validation types expected by the system" do
    array = ['Presence', 'Uniqueness', 'Length']
    ModelValidation.show.should == array
  end
end
