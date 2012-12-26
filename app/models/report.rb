class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  field :report_name, type: String

  has_many :report_attributes
  belongs_to :user

  validates_presence_of :report_name

  attr_accessible :report_name, :report_attributes, :sources_attributes
end
