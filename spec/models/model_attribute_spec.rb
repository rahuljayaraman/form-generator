require 'spec_helper'

describe ModelAttribute do
  it { should have_fields(:field_name, :field_type) }
  it { should be_embedded_in(:source) }
end
