class Form
  include Mongoid::Document
  include Mongoid::Timestamps

  field :form_name, type: String

  belongs_to :source
  belongs_to :user
  has_many :form_attributes, dependent: :destroy

  validates_presence_of :form_name
  validates_uniqueness_of :form_name

  accepts_nested_attributes_for :form_attributes, :allow_destroy => true, :allow_nil => false
  attr_accessible :form_name, :source_id, :form_attributes_attributes

  def source_attributes
    form_attributes.map(&:source_attribute).uniq
  end
end
