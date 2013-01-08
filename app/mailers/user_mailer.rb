class UserMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "notifications@forbestechnosys.com"

  def activation_needed_email user, application_id
    @user = User.find user
    @url  = users_url + "/#{@user.activation_token}/activate"
    @application = @user.used_applications.find application_id
    mail(:to => "recklessrahul@gmail.com",
         :subject => "Please join #{@application.application_name}")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_success_email.subject
  #
  def activation_success_email user, application_id
    @user = user
    @url  = login_url
    @application = @user.used_applications.find application_id
    mail(:to => "recklessrahul@gmail.com",
         :subject => "Your account has been activated")
  end
end
