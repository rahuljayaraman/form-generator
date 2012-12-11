class Source
  include Mongoid::Document
  include Mongoid::Timestamps

  field :set_name, type: String
  field :user_id, type: Integer

  embeds_many :model_attributes
  accepts_nested_attributes_for :model_attributes, :allow_destroy => true

  attr_accessible :set_name, :user_id, :model_attributes_attributes

  belongs_to :user

  validates_presence_of :user_id, :set_name
  validates_uniqueness_of :set_name, scope: :user_id


  def initialize_set
    model_name = self.set_name.gsub(' ','').classify
    klass_name = "#{model_name}#{self.user.id}"
    object = self
    klass =  klass_name.not_loaded ? Class.new : eval(klass_name)

    klass.class_eval do
      include Mongoid::Document
      store_in collection: self.collection_name
      object.model_attributes.each do |m|
        field m.field_name.gsub(' ','').underscore, type: object.class.mapping[m.field_type]
      end
      
      def self.collection_name
        self.name.tableize
      end
    end
    Object.const_set klass_name, klass
  end

  def self.mapping
    { 'Word' => String, 'Number' => Integer, 'True or False' => Boolean, 'Date & Time' => DateTime, 'Date' => Date, 'Time' => Time }
  end
end
