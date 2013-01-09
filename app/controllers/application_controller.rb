class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_login

  def authorize
    unless permission.allow?
      redirect_to :back, alert: "Not authorized!"
    end
  end

  def permission
    @permission ||= Permission.new current_user, params
  end

  protected
  def not_authenticated
      redirect_to login_path, :alert => "You're not authorized to access this page. Please login first."
  end
end
