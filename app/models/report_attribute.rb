class ReportAttribute
  include Mongoid::Document

  belongs_to :report
  belongs_to :source_attribute
end
