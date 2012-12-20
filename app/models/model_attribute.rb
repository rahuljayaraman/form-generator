class ModelAttribute
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :field_name, :field_type

  field :field_name, type: String
  field :field_type, type: String

  attr_accessible :field_name, :field_type, :model_validation_attributes

  belongs_to :source
  embeds_many :model_validations
  accepts_nested_attributes_for :model_validations, :allow_destroy => true

  has_many :report_parameters

end
