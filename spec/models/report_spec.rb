require 'spec_helper'

describe Report do
  it { should have_fields(:report_name) }
  it { should validate_presence_of(:report_name) }
  it { have_and_belong_to_many(:source_attributes) }
  it { should have_and_belong_to_many :roles }
  it { should belong_to(:user) }

  context "Methods" do
    let(:source) { Fabricate :source }
    let(:report) { Report.new(report_name: "Testing", source_attribute_ids: [source.source_attributes.last.id]) }
    subject { report }

    its(:find_sources) { should include source }

    it "should be able to search & filter records based on params provided" do
      attributes = Hash[report.find_attribute_names.map {|name| [name.attribute.to_sym, "123"]}]
      report_sources = report.find_sources
      Source.stub(:search)
      Source.should_receive(:search).with(report_sources, attributes)
      report.search attributes
    end
  end
end
