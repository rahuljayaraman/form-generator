class Source
  include Mongoid::Document
  include Mongoid::Timestamps

  field :set_name, type: String
  field :user_id, type: Integer

  belongs_to :user

  validates_presence_of :user_id, :set_name

  def initialize_set(model_name)
    model_name = model_name.classify
    klass = Class.new do
      include Mongoid::Document
      def self.wrap 
        with(collection: self.name.tableize)
      end
    end
    klass_name = "#{model_name}#{self.user.id}"
    Object.const_set klass_name, klass

    collection_name = create_collection(klass_name)
    klass
  end


  private

  def create_collection(klass = self)
    eval(klass).mongo_session.with(database: "bootstrap_data_#{Rails.env.downcase}") do |session|
      session.command(create: klass.tableize )
    end
    klass.tableize
  end


end
