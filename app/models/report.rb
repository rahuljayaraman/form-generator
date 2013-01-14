class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  field :report_name, type: String
  field :user_attributes, type: Array

  belongs_to :user
  belongs_to :source
  has_and_belongs_to_many :source_attributes, inverse_of: nil
  has_and_belongs_to_many :roles

  validates_presence_of :report_name

  attr_accessible :report_name, :source_attribute_ids, :source_id, :user_attributes

  def find_model
    source.initialize_dynamic_model
  end

  def find_attribute_names
    source_attributes.map(&:field_name)
  end

  def search attr
    source.search_models attr
  end

  def find_direct_attributes
    source_attributes.where(source_id: self.source_id)
  end

  def find_belongs_to_attributes
    belongs_to_ids = self.source.belongs_tos.map(&:id)
    source_attributes.where(:source_id.in => belongs_to_ids)
  end

  def find_habtm_attributes
    habtm_ids = self.source.habtms.map(&:id)
    source_attributes.where(:source_id.in => habtm_ids)
  end

  def find_has_many_attributes
    has_many_ids = self.source.has_manies.map(&:id)
    source_attributes.where(:source_id.in => has_many_ids)
  end
end
