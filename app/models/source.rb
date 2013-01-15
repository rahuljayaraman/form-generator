class Source
  include Mongoid::Document
  include Mongoid::Timestamps
  include DynamicModel
  extend Mapping

  field :source_name, type: String

  has_many :source_attributes, dependent: :destroy
  belongs_to :user
  has_many :forms, dependent: :destroy

  has_and_belongs_to_many :has_manies, class_name: "Source", inverse_of: :belongs_tos, dependent: :nullify
  has_and_belongs_to_many :belongs_tos, class_name: "Source", inverse_of: :has_manies, dependent: :nullify
  has_and_belongs_to_many :habtms, class_name: "Source", inverse_of: :habtms

  accepts_nested_attributes_for :source_attributes, :allow_destroy => true

  validates_presence_of :user_id, :source_name
  validates_uniqueness_of :source_name, scope: :user_id

  attr_accessible :source_name, :user_id, :source_attributes_attributes, :has_many_ids, :belongs_to_ids, :habtm_ids

  after_save :remove_unrelated_form_attributes

  def collection_name_helper
    user_id = self.user.id
    klass_name = self.source_name.attribute.classify
    (klass_name + user_id).tableize
  end

  def remove_unrelated_form_attributes
    FormAttribute.cleanup_relationships self
  end

  def search_models attr
    # attr = {model: {}, belongs_to: {source_id: {hash of attributes & values}}}
    belongs_to = {}
    if attr[:belongs_to]
      attr[:belongs_to].keys.each do |source_id|
        attr[:belongs_to][source_id].each do |key, value|
          attr[:belongs_to][source_id].delete key if value.blank?
        end
        if source_id == "user"
          if attr[:belongs_to]["user"].empty?
            attr[:belongs_to].delete "user"
          else
            belongs_to["user"] = [] unless belongs_to[source_id.to_sym]
            belongs_to["user"] += User.search(attr[:belongs_to]["user"]).map(&:id)
            attr[:belongs_to].delete "user"
          end
        else
          source = Source.find source_id
          belongs_to[source_id] = [] unless belongs_to[source_id.to_sym]
          belongs_to[source_id] += source.search(attr[:belongs_to][source_id]).map(&:id) unless attr[:belongs_to][source_id].empty?
        end
      end
    end
    # ({:quia=>""}, {:"50eea19581ee9e61a7000013"=>[1, 2, 3]})
    belongs_to = nil if belongs_to.empty?
    records = self.search attr[:model], belongs_to
  end

  def search attr, belongs_to = nil
    initialize_dynamic_model.search attr, belongs_to
  end

  def belongs_tos_attributes
    belongs_tos.map(&:source_attributes).inject([]){|initial,sum| initial + sum}
  end

  def has_manies_attributes
    has_manies.map(&:source_attributes).inject([]){|initial,sum| initial + sum}
  end

  def habtms_attributes
    habtms.map(&:source_attributes).inject([]){|initial,sum| initial + sum}
  end
end
