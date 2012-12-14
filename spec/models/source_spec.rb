require 'spec_helper'

describe Source do
  it { should have_fields(:set_name) }
  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:set_name).scoped_to(:user_id) }
  it { should embed_many(:model_attributes) }

  it "should always be associated with a user" do
    Fabricate.build(:source, user: "").should_not be_valid
  end

end


