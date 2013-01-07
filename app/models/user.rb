class User
  include Mongoid::Document
  authenticates_with_sorcery!

  field :name, type: String
  field :email, type: String
  field :crypted_password, type: String
  field :salt, type: String
  field :activation_state,            type: String
  field :activation_token,            type: String
  field :activation_token_expires_at, type: DateTime

  index({ activation_token: 1 }, { unique: true, background: true })

  has_many :sources
  has_many :reports
  has_many :forms
  has_many :owned_applications, class_name: "Application", inverse_of: :owner
  has_and_belongs_to_many :used_applications, class_name: "Application", inverse_of: :members

  attr_accessible :name, :email, :password, :password_confirmation

  validates_length_of :password, :minimum => 5, :message => "password must be at least 5 characters long", :if => :password
  validates_confirmation_of :password, :message => "should match confirmation", :if => :password
  validates_uniqueness_of :email

  def self.define_relationships associated
    associated.each do |model|
      User.has_many model.collection_name.to_sym, inverse_of: :user, inverse_class_name: 'User'
      model.belongs_to :user, inverse_of: model.name.underscore.to_sym, inverse_class_name: model.name.classify
    end
  end

end
