require 'spec_helper'

describe ModelAttribute do
  it { should have_fields(:field_name, :field_type) }
  it { should belong_to(:source) }
  it { should embed_many(:model_validations) }

  it "should have name & type as mandatory fields" do
    Fabricate.build(:model_attribute, field_type: "").should_not be_valid
  end
end
