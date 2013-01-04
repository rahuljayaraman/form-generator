class FormAttribute
  include Mongoid::Document
  include Mongoid::Timestamps

  field :priority, type: Integer, default: 999999

  belongs_to :form
  belongs_to :source_attribute

  attr_accessible :form_id, :source_attribute_id, :priority

  validates_presence_of :source_attribute_id

  default_scope order_by(:priority => :asc)

  def self.cleanup_relationships source
    forms = source.forms
    forms.each do |form|
      has_manies = source.has_manies.map(&:source_attributes).inject([]){|initial, val| initial + val}.map(&:id)
      belongs_tos = source.belongs_tos.map(&:source_attributes).inject([]){|initial, val| initial + val}.map(&:id)
      original_attributes = source.source_attributes.map(&:id)

      source_attribute_ids = has_manies + belongs_tos + original_attributes

      attributes = form.form_attributes.not_in(source_attribute_id: source_attribute_ids) 
      attributes.destroy_all
    end
  end
end
