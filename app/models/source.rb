require 'string_helpers'
class Source
  include Mongoid::Document
  include Mongoid::Timestamps

  field :source_name, type: String

  has_many :source_attributes
  belongs_to :user
  has_and_belongs_to_many :reports

  accepts_nested_attributes_for :source_attributes, :allow_destroy => true

  validates_presence_of :user_id, :source_name
  validates_uniqueness_of :source_name, scope: :user_id

  attr_accessible :source_name, :user_id, :source_attributes_attributes


  def initialize_dynamic_model
    model_name = self.source_name.gsub(' ','').classify
    klass_name = "#{model_name}#{self.user.id}"
    object = self

    klass = Class.new do
      include Mongoid::Document
      include ActiveModel::Validations
      store_in collection: self.collection_name
      field_names = []
      object.source_attributes.each do |m|
        field m.field_name.attribute.to_sym, type: object.class.mapping[m.field_type]
        attr_accessible m.field_name.attribute.to_sym
      end

      object.source_attributes.where(field_type: "Number").map(&:field_name).each do |o|
        validates_numericality_of o.attribute.to_sym, allow_blank: true
      end

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
