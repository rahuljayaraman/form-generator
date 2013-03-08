require 'spec_helper'

describe 'Dynamic Model', focus: true do
  let(:source) { Fabricate.build(:source) }
  let(:model) { source.initialize_dynamic_model }
  let(:fields) { source.source_attributes }
  let(:field_name) { fields.last.field_name }
  subject { model }

  it "should destroy collection when related source is destroyed" do
    source.save
    hash = {field_name.to_sym => "123"}
    record = model.create(hash)
    model.count.should == 1
    source.destroy
    model.count.should == 0
  end

  it "should include relationships defined" do
    user = stub(id: "123")
    next_source = stub(:next_source).as_null_object
    source.stub(:has_manies) { [next_source] }
    next_source.stub(:source_name) {"next source"}
    source.stub(:user) { user }
    model = source.initialize_dynamic_model
    model.new.should respond_to "#{'next source'.attribute + "123"}".tableize
  end

  it "should have fields defined with appropriate types" do
    fields.each do |f|
      subject.should have_field(f.field_name).of_type(Source.mapping[f.field_type.to_sym])
    end
  end
  
  it "should restrict data to datatype" do
    subject.new(field_name => "ABC").send(field_name).should_not == "ABC"
  end

  it "should allow blank entries if validations not given" do
    subject.new(field_name=> "").should be_valid
  end

  #Specs to ascertain Model sanity

  it { should be_instance_of(Class) }
  its('collection.name') { should_not == '' }

  context "Validations" do
    let(:source_attribute) { source.source_attributes.last}

    it "should validate presence" do
      source_attribute.model_validations.build(validation_type: "Presence") 
      model = source.initialize_dynamic_model
      model.create(field_name => "").should_not be_valid
    end

    it "should validate min length" do
      source_attribute.model_validations.build(validation_type: "Length", min: 5) 
      model = source.initialize_dynamic_model
      model.create(field_name => "1234").should_not be_valid
    end

    it "should validate max length" do
      source_attribute.model_validations.build(validation_type: "Length", max: 5) 
      model = source.initialize_dynamic_model
      model.create(field_name => "123456").should_not be_valid
    end

    it "should validate uniqueness" do
      source_attribute.model_validations.build(validation_type: "Uniqueness") 
      model = source.initialize_dynamic_model
      model.create(field_name => "123456")
      model.create(field_name => "123456").should_not be_valid
    end

    it "should use custom message" do
      source_attribute.model_validations.build(validation_type: "Presence", message: "ABCD") 
      model = source.initialize_dynamic_model
      instance = model.create(field_name => "")
      instance.errors.messages.values[0][0].should == "ABCD"
    end

    it "should default to standard message when nothing provided" do
      source_attribute.model_validations.build(validation_type: "Presence") 
      model = source.initialize_dynamic_model
      instance = model.create(field_name => "")
      instance.errors.messages.values[0][0].should_not == ""
    end
  end
end
