require 'spec_helper'

describe Report do
  it { should have_fields(:report_name) }
  it { should validate_presence_of(:report_name) }
  it { have_and_belong_to_many(:source_attributes) }
  it { should belong_to(:user) }

  it "should find associated sources" do
    source = Fabricate :source
    report = Report.new(report_name: "Testing", source_attribute_ids: [source.source_attributes.last.id])
    report.find_sources.should include source
  end
end
