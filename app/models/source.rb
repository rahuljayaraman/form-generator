class Source
  include Mongoid::Document
  include Mongoid::Timestamps

  field :set_name, type: String
  field :user_id, type: Integer

  belongs_to :user

  validates_presence_of :user_id, :set_name
  validates_uniqueness_of :set_name, scope: :user_id

  def initialize_set
    model_name = self.set_name.classify
    klass_name = "#{model_name}#{self.user.id}"
    if klass_name.not_loaded?
      klass = Class.new do
        include Mongoid::Document
        def self.wrap 
          with(collection: self.name.tableize)
        end
      end
      Object.const_set klass_name, klass

      collection_name = create_collection(klass_name) if klass.wrap.collection.name.blank?
      klass
    else
      raise "Model has been loaded."
    end
  end



  private

  def create_collection(klass)
    eval(klass).mongo_session.with(database: "bootstrap_data_#{Rails.env.downcase}") do |session|
      session.command(create: klass.tableize )
    end
    klass.tableize
  end

end


