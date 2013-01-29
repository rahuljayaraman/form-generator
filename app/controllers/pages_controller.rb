class PagesController < ApplicationController
  skip_before_filter :require_login

  def home
    redirect_to user_path(current_user) if current_user
    @user = User.new
  end
end
