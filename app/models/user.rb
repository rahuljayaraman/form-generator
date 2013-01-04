class User
  include Mongoid::Document
  authenticates_with_sorcery!

  field :name, type: String
  field :email, type: String
  field :crypted_password, type: String
  field :salt, type: String

  has_many :sources
  has_many :reports
  has_many :forms

  attr_accessible :name, :email, :password, :password_confirmation

  validates_length_of :password, :minimum => 5, :message => "password must be at least 5 characters long", :if => :password
  validates_confirmation_of :password, :message => "should match confirmation", :if => :password
  validates_uniqueness_of :email

  def self.define_relationships associated
    associated.each do |model|
      User.has_many model.collection_name.to_sym
      model.belongs_to :user
    end
  end

end
