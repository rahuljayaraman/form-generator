class Application
  include Mongoid::Document
  field :application_name, type: String
  field :application_description, type: String

  has_and_belongs_to_many :members, class_name: "User", inverse_of: :used_applications
  belongs_to :owner, class_name: "User", inverse_of: :owned_applications

  validates_presence_of :application_name

  def add_members users
    users.each do |email|
      user = User.create_temporary_user email
      self.members << user
      user.send_activation_email self.id
    end
  end
end
