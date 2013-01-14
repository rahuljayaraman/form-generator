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
  field :builder, type: Boolean
  field :inviter, type: Boolean

  index({ activation_token: 1 }, { unique: true, background: true })

  has_many :sources
  has_many :reports
  has_many :forms
  has_many :owned_applications, class_name: "Application", inverse_of: :owner
  has_and_belongs_to_many :used_applications, class_name: "Application", inverse_of: :members
  has_and_belongs_to_many :roles

  attr_accessible :name, :email, :password, :password_confirmation, :role_ids

  validates :email, presence: true, uniqueness: true
  validates :password,   :presence => true, :confirmation => true, :if => :activated?
  validates :name,  :presence => true, :if => :activated?
  
  #Sorcery can bypass password validations after this
  before_create :setup_activation
  def external?
    false
  end

  def activated?
    self.activation_state == 'active'
  end

  def self.define_relationships associated
    associated.each do |model|
      User.has_many model.collection_name.to_sym, inverse_of: :user, inverse_class_name: 'User'
      model.belongs_to :user, inverse_of: model.name.underscore.to_sym, inverse_class_name: model.name.classify
    end
  end

  def self.create_temporary_user email
    self.create email: email
  end

  def send_activation_email application_id
    UserMailer.activation_needed_email(self.id, application_id).deliver
  end

  def send_confirmation_email application_id
    UserMailer.activation_success_email(self.id, application_id).deliver
  end

  def app_roles app_id
    roles.where(application_id: app_id)
  end

  def app_forms app_id
    roles = self.app_roles app_id
    roles.map(&:forms).inject([]) {|initial, sum| initial + sum }
  end

  def app_reports app_id
    roles = self.app_roles app_id
    roles.map(&:reports).inject([]) {|initial, sum| initial + sum }
  end

  def owns_application app
    owned_applications.include? app
  end

  def send_builder_invitation sender
    UserMailer.send_builder_invitation(self.id, sender).deliver
  end

  def confirm_builder_invitation sender
    UserMailer.confirm_builder_invitation(self.id, sender).deliver
  end

  def find_or_send_invitations emails
    emails.each do |email|
      user = User.find_by_email email
      if user
        if !user.builder?
          self.confirm_builder_invitation user.id
          user.update_attribute(:builder, true)
        end
      else
        user = User.create_temporary_user(email)
        user.update_attribute(:builder, true)
        self.send_builder_invitation user.id
      end
    end
  end

  def self.available_attributes
    ['Name', 'Email']
  end
end
