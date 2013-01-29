require 'roo'
class Source
  class NoHeader < RuntimeError; end
  include Mongoid::Document
  include Mongoid::Timestamps
  include DynamicModel
  extend Mapping

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
  before_destroy :delete_collection

  def collection_name_helper
    user_id = self.user.id
    klass_name = self.source_name.attribute
    (klass_name + user_id).classify.tableize
  end

  def remove_unrelated_form_attributes
    FormAttribute.cleanup_relationships self
  end

  def search_models attr
    # attr = {model: {}, belongs_to: {source_id: {hash of attributes & values}}}
    belongs_to = {}
    if attr[:belongs_to]
      attr[:belongs_to].keys.each do |source_id|
        attr[:belongs_to][source_id].each do |key, value|
          attr[:belongs_to][source_id].delete key if value.blank?
        end
        if source_id == "user"
          if attr[:belongs_to]["user"].empty?
            attr[:belongs_to].delete "user"
          else
            belongs_to["user"] = [] unless belongs_to[source_id.to_sym]
            belongs_to["user"] += User.search(attr[:belongs_to]["user"]).map(&:id)
            attr[:belongs_to].delete "user"
          end
        else
          unless attr[:belongs_to][source_id].empty?
            source = Source.find source_id
            belongs_to[source_id] = [] unless belongs_to[source_id.to_sym]
            belongs_to[source_id] += source.search(attr[:belongs_to][source_id]).map(&:id) unless attr[:belongs_to][source_id].empty?
          end
        end
      end
    end
    # ({:quia=>""}, {:"50eea19581ee9e61a7000013"=>[1, 2, 3]})
    belongs_to = nil if belongs_to.empty?
    records = self.search attr[:model], belongs_to
  end

  def search attr, belongs_to = nil
    initialize_dynamic_model.search attr, belongs_to
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
      type = guess_celltype spreadsheet.celltype(first_row+1, index)
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
end
