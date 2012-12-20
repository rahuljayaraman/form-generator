require 'spec_helper'

describe ReportParameter do
  it { should belong_to(:report) }
  it { should belong_to(:model_attribute) }
end
