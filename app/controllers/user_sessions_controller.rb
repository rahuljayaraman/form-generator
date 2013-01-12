class UserSessionsController < ApplicationController
  skip_before_filter :require_login, :except => [:destroy]
  def new
    current_user and redirect_to user_path(current_user)
    @user = User.new
  end

  def create
    if @user = login(params[:email],params[:password])
      redirect_back_or_to(user_path(@user), :notice => 'Login successful.') 
    else
      redirect_back_or_to(root_path, :alert => "Login failed!")
    end
  end

  def destroy
    logout
    redirect_to(root_path, :alert => 'Logged out!')
  end
end

