module DynamicModel
  def initialize_dynamic_model
    model_name = self.source_name.attribute.classify
    klass_name = "#{model_name}#{self.user.id}"
    object = self

    klass = Class.new do
      include Mongoid::Document
      include Mongoid::Timestamps
      include ActiveModel::Validations
      include Mongoid::MultiParameterAttributes

      store_in collection: self.collection_name
      field_names = []
      object.source_attributes.each do |m|
        field m.field_name.attribute.to_sym, type: object.class.mapping[m.field_type]
        attr_accessible m.field_name.attribute.to_sym
      end

      #Relationships
      object.has_manies.each do |h|
        object_model_name = h.source_name.attribute.classify
        object_klass_name = "#{object_model_name}#{object.user.id}"
        has_many object_klass_name.tableize.to_sym, inverse_of: klass_name.underscore.to_sym, inverse_class_name: klass_name
        attr_field = object_klass_name.underscore + "_ids"
        attr_accessible attr_field.to_sym
      end

      object.belongs_tos.each do |h|
        object_model_name = h.source_name.attribute.classify
        object_klass_name = "#{object_model_name}#{object.user.id}"
        belongs_to object_klass_name.underscore.to_sym, inverse_of: klass_name.underscore.to_sym, inverse_class_name: klass_name
        attr_field = object_klass_name.underscore + "_id"
        attr_accessible attr_field.to_sym
      end

      object.habtms.each do |h|
        object_model_name = h.source_name.attribute.classify
        object_klass_name = "#{object_model_name}#{object.user.id}"
        has_and_belongs_to_many object_klass_name.tableize.to_sym, inverse_of: klass_name.underscore.to_sym, inverse_class_name: klass_name
        attr_field = object_klass_name.underscore + "_ids"
        attr_accessible attr_field.to_sym
      end

      #Validates Presence
      object.source_attributes.each do |s|
        validates_presence_of s.field_name.attribute.to_sym, message: s.fetch_message('presence') if s.validate_presence_of 'presence'
      end

      #Validates Length
      object.source_attributes.each do |source_attribute|
        validates_length_of source_attribute.field_name.attribute.to_sym, minimum: source_attribute.fetch_min, maximum: source_attribute.fetch_max if source_attribute.validate_presence_of 'length'
      end

      #Validates Uniqueness
      object.source_attributes.each do |s|
        validates_uniqueness_of s.field_name.attribute.to_sym if s.validate_presence_of 'uniqueness'
      end

      def self.collection_name
        self.name.tableize
      end
    end

    Object.send(:remove_const, klass_name.to_sym) unless klass_name.not_loaded
    Object.const_set klass_name, klass
  end
end
