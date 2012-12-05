require 'spec_helper'

describe Source do
  it { should have_fields(:set_name) }
  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:set_name).scoped_to(:user_id) }

  it "should always be associated with a user" do
    build(:source, user_id: "").should_not be_valid
  end

  context "Dynamic Model" do
    let(:set) { create(:source) }
    let(:klass) { set.initialize_set }
    subject { klass }

    it { should be_instance_of(Class) }
    its('collection.name') { should_not == '' }
    
    it "should persist data permanently" do
       subject.create(name: "Rahul")
       klass.last.name.should == 'Rahul'
    end

    it "raise an error with an already existing class is being re-initialized"  do
      expect { set.initialize_set(set.set_name.classify) }.to raise_error
    end

    it "should be able to destroy records" do
      entry = subject.create(name: "Rahul")
      entry.destroy
      klass.last.should_not == entry
    end
  end

end


