class Application
  include Mongoid::Document
  field :application_name, type: String
  field :application_description, type: String

  has_many :roles
  has_and_belongs_to_many :members, class_name: "User", inverse_of: :used_applications
  belongs_to :owner, class_name: "User", inverse_of: :owned_applications

  validates_presence_of :application_name

  def remove_member user_id
    member = self.members.find_by_id user_id
    members.delete member
  end

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

  def send_confirmation_email user
    user.send_confirmation_email self.id
  end

  def add_member user
    self.members << user
    if user.activation_state == 'active'
      send_confirmation_email user
    else
      send_activation_email user
    end
  end
end
