require 'spec_helper'

describe ReportAttribute do
  it { should belong_to(:report) }
  it { should belong_to(:source_attribute) }
end
