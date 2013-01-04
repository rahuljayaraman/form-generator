class FormAttribute
  include Mongoid::Document
  include Mongoid::Timestamps

  field :priority, type: Integer, default: 999999

  belongs_to :form
  belongs_to :source_attribute

  attr_accessible :form_id, :source_attribute_id, :priority

  validates_presence_of :source_attribute_id

  default_scope order_by(:priority => :asc)
end
