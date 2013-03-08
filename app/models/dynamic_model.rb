module SearchWithTire
  class InvalidQuery < StandardError; end;
  class NoIndex < StandardError; end;
  class NoData < StandardError; end;
end

module DynamicModel
  def initialize_dynamic_model
    model_name = self.source_name.attribute
    klass_name = "#{model_name}#{self.user.id}".classify
    object = self

    klass = Class.new do
      include Mongoid::Document
      include Mongoid::Timestamps
      include ActiveModel::Validations
      include Mongoid::MultiParameterAttributes
      include Tire::Model::Search
      include Tire::Model::Callbacks

      store_in collection: self.collection_name
      @@user_method_list = []
      @@has_manies_method_list = []
      @@belongs_tos_method_list = []
      @@habtm_method_list = []
      object.source_attributes.each do |m|
        field m.field_name.attribute.to_sym, type: object.class.mapping[m.field_type]
        attr_accessible m.field_name.attribute.to_sym
      end
      #All dynamic models belong to user
      belongs_to :user, inverse_class_name: klass_name

      #Relationships
      object.has_manies.each do |h|
        object_model_name = h.source_name.attribute
        object_klass_name = "#{object_model_name}#{object.user.id}".classify
        has_many object_klass_name.tableize.to_sym, inverse_of: klass_name.underscore.to_sym, inverse_class_name: klass_name
        attr_field = object_klass_name.underscore + "_ids"
        attr_accessible attr_field.to_sym
      end

      object.belongs_tos.each do |h|
        object_model_name = h.source_name.attribute
        object_klass_name = "#{object_model_name}#{object.user.id}".classify
        belongs_to object_klass_name.underscore.to_sym, inverse_of: klass_name.underscore.to_sym, inverse_class_name: klass_name
        attr_field = object_klass_name.underscore + "_id"
        attr_accessible attr_field.to_sym
      end

      object.habtms.each do |h|
        object_model_name = h.source_name.attribute
        object_klass_name = "#{object_model_name}#{object.user.id}".classify
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

      def self.search query
        begin
          tire.search(per_page: 7) do
            query { string query[:q]} if query[:q].present?
            if query[:from].present? and query[:to].present?
              filter :range, created_at: {from: query[:from], to: query[:to]}
            end
            sort { by :created_at, "desc" } if query[:q].blank?
          end
        rescue Tire::Search::SearchRequestFailed => e
          if e.message.include? "Index"
            if import_search_index
              raise SearchWithTire::NoIndex
            else
              raise SearchWithTire::NoData
            end
          else
            raise SearchWithTire::InvalidQuery
          end
        end
      end

      #Defining methods for elastic search indexing
      object.has_manies.each do |relation|
        relation.source_attributes.each do |source_attribute|
          field_name = source_attribute.field_name.attribute
          method_name = "hm_#{relation.source_name.attribute}_#{field_name}"  
          @@has_manies_method_list << method_name
          define_method method_name do
            begin
              self.send(relation.collection_name_helper.attribute).send(field_name)
            rescue NoMethodError
              "N/A"
            end
          end
        end
      end

      object.habtms.each do |relation|
        relation.source_attributes.each do |source_attribute|
          field_name = source_attribute.field_name.attribute
          method_name = "habtm_#{relation.source_name.attribute}_#{field_name}" 
          @@habtm_method_list << method_name
          define_method method_name do
            begin
              self.send(relation.collection_name_helper.attribute).send(field_name)
            rescue NoMethodError
              "N/A"
            end
          end
        end
      end

      object.belongs_tos.each do |relation|
        relation.source_attributes.each do |source_attribute|
          field_name = source_attribute.field_name.attribute
          method_name = "bt_#{relation.source_name.attribute}_#{field_name}" 
          @@belongs_tos_method_list << method_name
          define_method method_name do
            begin
              self.send(relation.collection_name_helper.attribute.singularize).send(field_name)
            rescue NoMethodError
              "N/A"
            end
          end
        end
      end
      
      #Define user relations for Elastic search
      User.available_attributes.each do |field_name|
        method_name = "user_#{field_name.attribute}" 
        @@user_method_list << method_name
        define_method method_name do
          begin
            self.user.send(field_name.attribute)
          rescue NoMethodError
            "N/A"
          end
        end
      end

      def self.method_list
        @@user_method_list + @@belongs_tos_method_list + @@has_manies_method_list + @@habtm_method_list
      end

      def self.user_method_list
        @@user_method_list
      end

      def self.has_manies_method_list
        @@has_manies_method_list
      end

      def self.belongs_tos_method_list
        @@belongs_tos_method_list
      end

      def self.habtm_method_list
        @@habtm_method_list
      end

      def self.import_search_index
        self.tire.index.import self.all
      end

      def to_indexed_json
        to_json(methods: @@user_method_list + @@belongs_tos_method_list + @@has_manies_method_list + @@habtm_method_list)
      end
    end

    Object.send(:remove_const, klass_name.to_sym) unless klass_name.not_loaded
    Object.const_set klass_name, klass
  end
end
