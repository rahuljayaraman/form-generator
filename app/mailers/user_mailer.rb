class UserMailer < ActionMailer::Base
  default from: "recklessrahul@gmail.com"

  def activation_needed_email user, application
    @user = user
    @url  = users_url + "/#{user.activation_token}/activate"
    @application = application
    mail(:to => user.email,
         :subject => "Please join #{application.application_name}")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_success_email.subject
  #
  def activation_success_email user, application
    @user = user
    @url  = login_url
    mail(:to => user.email,
         :subject => "Your account has been activated")
  end
end
