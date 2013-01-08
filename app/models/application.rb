class Application
  include Mongoid::Document
  field :application_name, type: String
  field :application_description, type: String

  has_and_belongs_to_many :members, class_name: "User", inverse_of: :used_applications
  belongs_to :owner, class_name: "User", inverse_of: :owned_applications

  validates_presence_of :application_name

  def register_or_add users
    users.each do |email|
      if user = User.find_by_email(email)
        add_member user
      else
        register_user email
      end
    end
  end

  def register_user email
    user = User.create_temporary_user email
    add_member user
    send_activation_email user
    user
  end

  def send_activation_email user
    user.send_activation_email self.id
  end

  def add_member user
    self.members << user
  end
end
