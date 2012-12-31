class Source
  include Mongoid::Document
  include Mongoid::Timestamps
  include DynamicModel
  extend Mapping

  field :source_name, type: String
  field :hm_ids, type: Array, default: []
  field :bt_ids, type: Array, default: []

  has_many :source_attributes, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :source_attributes, :allow_destroy => true

  validates_presence_of :user_id, :source_name
  validates_uniqueness_of :source_name, scope: :user_id

  attr_accessible :source_name, :user_id, :source_attributes_attributes

  def has_manies 
    Source.any_in(id: hm_ids).all
  end

  def belongs_tos 
    Source.any_in(id: bt_ids).all
  end

  def add_has_many arr
    arr.each {|a| self. hm_ids << a }
  end

  def add_belongs_to arr
    arr.each {|a| self. bt_ids << a }
  end
end
