require 'spec_helper'

describe Source do
  it { should have_fields(:set_name) }
  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:set_name).scoped_to(:user_id) }
  it { should embed_many(:model_attributes) }

  it "should always be associated with a user" do
    Fabricate.build(:source, user: "").should_not be_valid
  end

  context "Class Methods" do
    subject { Source } 
    its(:mapping) { should be_instance_of(Hash)  }
    its(:view_mapping) { should be_instance_of(Hash)  }

    it "should return responses usable by simple_form" do
      subject.view_mapping['Word'].should == 'string'
      subject.view_mapping['Paragraph'].should == 'text'
      subject.view_mapping['Date & Time'].should == 'datetime'
      subject.view_mapping['Date'].should == 'date'
      subject.view_mapping['Time'].should == 'time'
      subject.view_mapping['Collection'].should == 'select'
      subject.view_mapping['Radio Buttons'].should == 'radio_buttons'
      subject.view_mapping['Check Boxes'].should == 'check_boxes'
      subject.view_mapping['Password'].should == 'password'
      subject.view_mapping['Email'].should == 'email'
      subject.view_mapping['Telephone'].should == 'tel'
      subject.view_mapping['True or False'].should == 'boolean'
    end
  end
end


