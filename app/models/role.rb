class Role
  include Mongoid::Document
  field :role_name, type: String
  field :role_description, type: String

  has_and_belongs_to_many :reports
  has_and_belongs_to_many :forms
  belongs_to :application

  validates_presence_of :role_name
end
