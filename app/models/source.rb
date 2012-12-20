class Source
  include Mongoid::Document
  include Mongoid::Timestamps
  require 'string_helpers'

  field :set_name, type: String

  has_many :model_attributes
  accepts_nested_attributes_for :model_attributes, :allow_destroy => true

  attr_accessible :set_name, :user_id, :model_attributes_attributes

  belongs_to :user
  has_and_belongs_to_many :reports

  validates_presence_of :user_id, :set_name
  validates_uniqueness_of :set_name, scope: :user_id


  def initialize_set
    model_name = self.set_name.gsub(' ','').classify
    klass_name = "#{model_name}#{self.user.id}"
    object = self

    klass = Class.new do
      include Mongoid::Document
      include ActiveModel::Validations
      store_in collection: self.collection_name
      field_names = []
      object.model_attributes.each do |m|
        field m.field_name.attribute.to_sym, type: object.class.mapping[m.field_type]
        attr_accessible m.field_name.attribute.to_sym
      end

      object.model_attributes.where(field_type: "Number").map(&:field_name).each do |o|
        validates_numericality_of o.attribute.to_sym, allow_blank: true
        # validates o.attribute.to_sym, numericality: true, allow_nil: true
      end

      # fields.each_pair do |k,v|
      #   v.try(:type)
      # end

      def self.collection_name
        self.name.tableize
      end
    end

    Object.send(:remove_const, klass_name.to_sym) unless klass_name.not_loaded
    Object.const_set klass_name, klass
  end

  def self.mapping
    { 
      'Word' => String,
      'Number' => Integer,
      'Paragraph' => String,
      'Date & Time' => DateTime,
      'Date' => Date,
      'Time' => Time,
      'Collection' => Array,
      'Radio Buttons' => Array,
      'Check Boxes' => Array,
      'Password' => String,
      'Email' => String,
      'Telephone' => String,
      'True or False' => Boolean
    }
  end

  def self.view_mapping
    { 
      'Word' => 'string',
      'Number' => 'integer',
      'Paragraph' => 'text',
      'Date & Time' => 'datetime',
      'Date' => 'date',
      'Time' => 'time',
      'Collection' => 'select',
      'Radio Buttons' => 'radio_buttons',
      'Check Boxes' => 'check_boxes',
      'Password' => 'password',
      'Email' => 'email',
      'Telephone' => 'tel',
      'True or False' => 'boolean'
    }
  end

end
