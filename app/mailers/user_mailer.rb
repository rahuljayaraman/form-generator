class UserMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "notifications@forbestechnosys.com"

  def activation_needed_email user, application_id
    @user = User.find user
    @url  = users_url + "/#{@user.activation_token}/activate"
    @application = @user.used_applications.find application_id
    mail(:to => @user.email,
         :subject => "Please join #{@application.application_name}")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_success_email.subject
  #
  def activation_success_email user, application_id
    @user = User.find user
    @application = @user.used_applications.find application_id
    @url  = application_url(@application)
    mail(:to => @user.email,
         :subject => "You have been added to #{@application.application_name}")
  end

  def send_builder_invitation sender, user
    @user = User.find user
    @sender = User.find sender
    @url  = users_url + "/#{@user.activation_token}/activate"
    mail(:to => @user.email,
         :subject => "App Generator | Builder Invite")
  end

  def confirm_builder_invitation sender, user
    @user = User.find user
    @sender = User.find sender
    @url = user_url(user)
    mail(:to => @user.email,
         :subject => "App Generator | Builder Confirmation")
  end
end
