require 'spec_helper'

describe ModelValidation do
  it { should be_embedded_in(:source_attribute) }
  it { should have_fields(:validation_type, :validation_options) }
end
