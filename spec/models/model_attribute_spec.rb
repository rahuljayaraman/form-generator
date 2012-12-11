require 'spec_helper'

describe ModelAttribute do
  it { should have_fields(:field_name, :field_type) }
  it { should be_embedded_in(:source) }

  it "should have name & type as mandatory fields" do
    ModelAttribute.create(field_name: "test").should_not be_valid
  end
end
