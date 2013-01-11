class UsersController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create, :activate, :confirm]
  before_filter :check_builder, :only => [:show]
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @sources = current_user.sources.all
    @reports = current_user.reports.all
    @forms = current_user.forms.all
    @applications = current_user.owned_applications.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    if @user.save
      reset_session
      auto_login(@user) 
      redirect_to user_path(@user), notice: "Your Account has been created."
    else
      render action: "new" 
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def activate
    logout
    if (@user = User.load_from_activation_token(params[:id]))
      if @user.activation_state == 'active'
        not_authenticated
      end
    else
      not_authenticated
    end
  end

  def confirm
    @user = User.find params[:id]
    @user.activate!
    if @user.update_attributes(params[:user])
      User.find_by_id(@user.id).update_attribute(:activation_state, "active")
      auto_login @user
      redirect_to @user, :notice => 'Your account has been activated!'
    else
      @user.activation_state = 'pending'
      render :activate
    end
  end

  def select_application
    @used_applications = current_user.used_applications 
  end

  def check_builder
    unless current_user.builder?
      redirect_to select_application_path
    end
  end
end

