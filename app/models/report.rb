class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  field :report_name, type: String

  belongs_to :user
  has_and_belongs_to_many :source_attributes, inverse_of: nil

  validates_presence_of :report_name

  attr_accessible :report_name, :source_attribute_ids

  def find_sources
    source_attributes.map(&:source)
  end
end
