require 'roo'
class Source
  class NoHeader < RuntimeError; end
  include Mongoid::Document
  include Mongoid::Timestamps
  include DynamicModel
  extend Mapping

  default_scope order_by("updated_at desc")

  field :source_name, type: String

  has_many :source_attributes, dependent: :destroy
  belongs_to :user
  has_many :forms, dependent: :destroy

  has_and_belongs_to_many :has_manies, class_name: "Source", inverse_of: :belongs_tos, dependent: :nullify
  has_and_belongs_to_many :belongs_tos, class_name: "Source", inverse_of: :has_manies, dependent: :nullify
  has_and_belongs_to_many :habtms, class_name: "Source", inverse_of: :habtms

  accepts_nested_attributes_for :source_attributes, :allow_destroy => true

  validates_presence_of :user_id, :source_name
  validates_uniqueness_of :source_name, scope: :user_id

  attr_accessible :source_name, :user_id, :source_attributes_attributes, :has_many_ids, :belongs_to_ids, :habtm_ids

  after_save :remove_unrelated_form_attributes
  after_destroy :delete_collection
  after_destroy :delete_index

  def collection_name_helper
    user_id = self.user.id
    klass_name = self.source_name.attribute
    (klass_name + user_id).classify.tableize
  end

  def remove_unrelated_form_attributes
    FormAttribute.cleanup_relationships self
  end

  def search_dynamic_model query
    model = self.initialize_dynamic_model
    model.search(query)
  end

  def belongs_tos_attributes
    belongs_tos.map(&:source_attributes).inject([]){|initial,sum| initial + sum}
  end

  def has_manies_attributes
    has_manies.map(&:source_attributes).inject([]){|initial,sum| initial + sum}
  end

  def habtms_attributes
    habtms.map(&:source_attributes).inject([]){|initial,sum| initial + sum}
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then Csv.new(file.path, nil, :ignore)
    when '.xls' then Excel.new(file.path, nil, :ignore)
    when '.xlsx' then Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end


  def self.build_headers(name, file, user)
    spreadsheet = open_spreadsheet(file)
    first_row = spreadsheet.first_row
    header = spreadsheet.row(first_row)
    # guess_type = spreadsheet.row(first_row + 1)
    source = user.sources.new(source_name: name)
    header.each_with_index do |value, index|
      raise NoHeader unless value
      type = guess_celltype spreadsheet.celltype(first_row+1, index+1)
      source.source_attributes.build(field_name: value, field_type: type)
    end
    { source: source, header: header, spreadsheet: spreadsheet }
  end

  def self.import_data(source, header, spreadsheet, user)
    header = header.collect { |val| val.to_s.gsub(/[^0-9a-zA-Z]/i, '').underscore }
    model = source.initialize_dynamic_model
    User.define_relationships [model]
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      data = user.send(model.collection_name).new(row.to_hash)
      data.save
    end
    model
  end

  def self.guess_celltype sym
    case sym
    when :string, :formula
      type = "String"
    when :float, :percentage
      type = "Number"
    when :date
      type = "Date"
    when :datetime
      type =  "Date & Time"
    when :time
      type = "Time"
    else
      type = "String"
    end
  end

  def delete_collection
    initialize_dynamic_model.collection.drop
  end

  def delete_index
    index_name = initialize_dynamic_model.collection_name
    Tire.index index_name do
      delete
    end
  end
end
