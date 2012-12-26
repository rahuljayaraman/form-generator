class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  field :report_name, type: String

  has_many :report_attributes
  belongs_to :user

  validates_presence_of :report_name

  attr_accessible :report_name, :report_attributes_attributes, :sources_attributes

  accepts_nested_attributes_for :report_attributes, allow_blank: false, allow_destroy: true, :reject_if => :all_blank
end
