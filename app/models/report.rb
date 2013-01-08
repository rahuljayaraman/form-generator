class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  field :report_name, type: String

  belongs_to :user
  has_and_belongs_to_many :source_attributes, inverse_of: nil
  has_and_belongs_to_many :roles

  validates_presence_of :report_name

  attr_accessible :report_name, :source_attribute_ids

  def find_model
    find_sources.last.initialize_dynamic_model
  end

  def find_sources
    source_attributes.map(&:source)
  end

  def find_attribute_names
    source_attributes.map(&:field_name)
  end

  def search attr
   sources = find_sources
   Source.search sources, attr
  end
end
