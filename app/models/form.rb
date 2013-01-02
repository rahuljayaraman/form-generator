class Form
  include Mongoid::Document
  include Mongoid::Timestamps

  field :form_name, type: String

  has_and_belongs_to_many :source_attributes, inverse_of: nil
  belongs_to :source
  belongs_to :user

  validates_presence_of :form_name
  validates_uniqueness_of :form_name

  attr_accessible :form_name, :source_attribute_ids, :source_id
end
