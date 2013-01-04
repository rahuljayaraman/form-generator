require 'spec_helper'

describe FormAttribute do
  it { should belong_to :form }
  it { should belong_to :source_attribute }
  it { should have_fields :priority }
end
