class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  field :report_name, type: String

  has_and_belongs_to_many :sources
  has_many :report_parameters
  belongs_to :user

  validates_presence_of :report_name

  attr_accessible :report_name, :report_parameters_attributes, :sources_attributes
end
