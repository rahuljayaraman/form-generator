class ReportParameter
  include Mongoid::Document

  belongs_to :report
  belongs_to :model_attribute
end
