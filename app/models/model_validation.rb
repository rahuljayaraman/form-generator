class ModelValidation
  include Mongoid::Document

  field :validation_type, type: String
  field :min, type: Integer
  field :max, type: Integer
  field :message, type: String

  attr_accessible :validation_type, :min, :max, :message

  embedded_in :source_attribute

  def self.show
    ['Presence', 'Uniqueness', 'Length']
  end
end
