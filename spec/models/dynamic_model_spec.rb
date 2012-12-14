require 'spec_helper'

describe 'Dynamic Model' do
  let(:user) { Fabricate(:user) }
  let(:model) { user.sources.last.initialize_set }
  let(:fields) { user.sources.last.model_attributes }
  let(:field_names) { fields.map(&:field_name) }
  subject { model }

  it "should have fields defined with appropriate types" do
    fields.each do |f|
      subject.should have_field(f.field_name).of_type(Source.mapping[f.field_type.to_sym])
    end
  end
  
  it "should restrict data to datatype" do
    fields.create(field_name: "Test", field_type: "Number")
    subject.create("Test" => "ABC").should_not be_valid
  end

  #Specs to ascertain Model sanity

  it { should be_instance_of(Class) }
  its('collection.name') { should_not == '' }

  it "should persist data permanently" do
    fields.create(field_name: :name, field_type: "Word")
    subject.create(name: "Rahul")
    subject.last.name.should == 'Rahul'
  end

  it "should be able to destroy records" do
    entry = subject.create(name: "Rahul")
    entry.destroy
    subject.last.should_not == entry
  end
end
