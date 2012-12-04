class PagesController < ApplicationController
  skip_before_filter :require_login

  def home
    @user = User.new
  end
end
