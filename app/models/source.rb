class Source
  include Mongoid::Document
  include Mongoid::Timestamps
  include DynamicModel
  extend Mapping

  field :source_name, type: String

  has_many :source_attributes, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :source_attributes, :allow_destroy => true

  validates_presence_of :user_id, :source_name
  validates_uniqueness_of :source_name, scope: :user_id

  attr_accessible :source_name, :user_id, :source_attributes_attributes
end
