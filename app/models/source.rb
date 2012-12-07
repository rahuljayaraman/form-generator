class Source
  include Mongoid::Document
  include Mongoid::Timestamps

  field :set_name, type: String
  field :user_id, type: Integer

  embeds_many :model_attributes
  accepts_nested_attributes_for :model_attributes, :reject_if => :all_blank, :allow_destroy => true

  attr_accessible :set_name, :user_id, :model_attributes_attributes

  belongs_to :user

  validates_presence_of :user_id, :set_name
  validates_uniqueness_of :set_name, scope: :user_id


  def initialize_set
    model_name = self.set_name.classify
    klass_name = "#{model_name}#{self.user.id}"
    if klass_name.not_loaded?
      klass = Class.new do
        include Mongoid::Document
        store_in collection: self.collection_name
        def self.collection_name
          self.name.tableize
        end
      end
      Object.const_set klass_name, klass
    else
      raise "Model loaded"
    end
  end
end


