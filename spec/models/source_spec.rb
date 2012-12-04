require 'spec_helper'

describe Source do
  it { should have_fields(:set_name) }
  it { should belong_to(:user) }
  it { should validate_uniquess_of(:set_name).scoped_to(:user) }

  it "should always be associated with a user" do
    build(:source, user_id: "").should_not be_valid
  end

  context "Dynamic Model", focus: true do
    let(:set) { create(:source) }
    let(:klass) { set.initialize_set(set.set_name.classify) }
    subject { klass.wrap }

    it { should be_instance_of(Class) }

    it "should assign a collection automatically" do
      subject.collection.name.should_not == ""
      eval(klass.to_s).collection.name.should == ""
    end

    it "should persist data permanently" do
       subject.create(name: "Rahul").should be_valid
       eval(klass.to_s).wrap.last.name.should == 'Rahul'
    end

    it "should respond to source" 
  end

end


