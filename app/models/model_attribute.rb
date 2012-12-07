class ModelAttribute
  include Mongoid::Document
  include Mongoid::Timestamps

  field :field_name, type: String
  field :field_type, type: String

  embedded_in :source
  validates_presence_of :field_name, :field_type

end
