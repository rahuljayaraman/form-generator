class Report
  include Mongoid::Document

  field :report_name, type: String

  has_and_belongs_to_many :sources
  has_many :report_parameters
  belongs_to :user

  validates_presence_of :report_name
end
