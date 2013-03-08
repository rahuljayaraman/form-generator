class SourceAttribute
  include Mongoid::Document
  include Mongoid::Timestamps

  field :field_name, type: String
  field :field_type, type: String
  field :hint, type: String

  attr_accessible :field_name, :field_type, :model_validations_attributes, :hint

  belongs_to :source
  embeds_many :model_validations
  has_many :form_attributes, dependent: :destroy

  validates_presence_of :field_name, :field_type

  accepts_nested_attributes_for :model_validations, :allow_destroy => true

  def validate_presence_of attr
    model_validations.where(validation_type: attr.humanize).count > 0
  end

  def fetch_min
    val = model_validations.where(validation_type: 'Length').last
    val.min || 0
  end

  def fetch_max
    val = model_validations.where(validation_type: 'Length').last
    val.max || 10000
  end

  def fetch_message attr
    val = model_validations.where(validation_type: attr.humanize).last
    val.message
  end

  def name_with_source
    "#{source.source_name} - #{field_name}"
  end

  def elastic_belongs_tos_method_name
    "bt_#{self.source.source_name.attribute}_#{self.field_name.attribute}" 
  end

  def elastic_has_manies_method_name
    "hm_#{self.source.source_name.attribute}_#{self.field_name.attribute}"  
  end

  def elastic_habtm_method_name
    "habtm_#{self.source.source_name.attribute}_#{self.field_name.attribute}"  
  end
end
