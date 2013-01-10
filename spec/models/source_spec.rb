require 'spec_helper'

describe Source do
  it { should have_fields(:source_name) }
  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:source_name).scoped_to(:user_id) }
  it { should have_many(:source_attributes) }
  it { should have_many :forms }

  it "should always be associated with a user" do
    Fabricate.build(:source, user: "").should_not be_valid
  end

  context "Search" do
    let(:source) { Fabricate.build :source }
    let(:next_source) { Fabricate.build :source, source_name: "belongs to" }
    let(:source_attribute) { source.source_attributes.last }

    it "should have a router search method to search & collate records from several models" do
      attr = {model: {source_attribute.field_name.attribute.to_sym => ""}, belongs_to: {next_source.id.to_s.to_sym =>[1,2,3]}}
      next_source.stub(:search) {[stub(id: 1), stub(id: 2), stub(id: 3)]}
      Source.stub(:find) {next_source}
      source.stub(:search)
      next_source.should_receive(:search).with(attr[:belongs_to][next_source.id.to_s.to_sym])
      source.should_receive(:search).with(attr[:model], {next_source.id.to_s.to_sym => [1,2,3]})
      source.search_models attr
    end

    it "should delegate search to dynamic model" do
      attr = {"123" => "456"}
      class NewTest; def self.search; end; end;
      source.stub(:initialize_dynamic_model) { NewTest }
      NewTest.should_receive(:search).with(attr, nil)
      source.search attr
    end
  end

  context "Dynamic Relationships" do
    let(:user) { Fabricate(:user) }
    let(:source) { user.sources.last }
    subject { source }
    
    it "should store habtm entries for both related sources"  do
      source =  Source.create source_name: "first", user_id: user.id
      next_source =  Source.create source_name: "next", user_id: user.id
      next_source.update_attributes :habtm_ids => [source.id]
      next_source.habtms.last.should == source
      source = Source.find source.id
      source.habtms.last.should == next_source
    end

    it "should accept arrays of self ids" do
      next_source = Source.new source_name: "Next"
      next_source.has_many_ids << source.id
      next_source.has_manies.last.should == source
    end

    it "should remove source_attributes references in form_attributes when references are removed" do
      next_source = Source.new source_name: "Next"
      next_source.has_many_ids << source.id
      next_source.user_id = "1233"
      FormAttribute.should_receive(:cleanup_relationships).with(next_source)
      next_source.save
    end
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


