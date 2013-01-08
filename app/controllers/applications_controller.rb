class ApplicationsController < ApplicationController
  # GET /applications
  # GET /applications.json
  def index
    @applications = current_user.owned_applications.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @applications }
    end
  end

  # GET /applications/1
  # GET /applications/1.json
  def show
    @application = current_user.owned_applications.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @application }
    end
  end

  # GET /applications/new
  # GET /applications/new.json
  def new
    @application = current_user.owned_applications.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @application }
    end
  end

  # GET /applications/1/edit
  def edit
    @application = current_user.owned_applications.find(params[:id])
  end

  # POST /applications
  # POST /applications.json
  def create
    @application = current_user.owned_applications.new(params[:application])

    respond_to do |format|
      if @application.save
        format.html { redirect_to user_path current_user, notice: 'Application was successfully created.' }
        format.json { render json: @application, status: :created, location: @application }
      else
        format.html { render action: "new" }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /applications/1
  # PUT /applications/1.json
  def update
    @application = current_user.owned_applications.find(params[:id])

    respond_to do |format|
      if @application.update_attributes(params[:application])
        format.html { redirect_to user_path current_user, notice: 'Application was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applications/1
  # DELETE /applications/1.json
  def destroy
    @application = current_user.owned_applications.find(params[:id])
    @application.destroy

    respond_to do |format|
      format.html { redirect_to user_path current_user }
      format.json { head :no_content }
    end
  end

  def invite
    raw_users = params[:users]
    split_users = raw_users.delete(" ").split(",")
    application = current_user.owned_applications.find params[:id]
    application.register_or_add split_users
    respond_to do |format|
      format.html { redirect_to application_path(application), notice: "#{view_context.pluralize(split_users.size, "User")} invited." }
      format.json { head :no_content }
    end
  end
end
