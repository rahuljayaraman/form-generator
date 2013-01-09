class RolesController < ApplicationController
  # GET /roles
  # GET /roles.json
  def index
    @roles = Role.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @roles }
    end
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
    @role = Role.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @role }
    end
  end

  # GET /roles/new
  # GET /roles/new.json
  def new
    @role = Role.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @role }
    end
  end

  # GET /roles/1/edit
  def edit
    @application = current_user.owned_applications.find(params[:application])
    @role = @application.roles.find(params[:id])
  end

  # POST /roles
  # POST /roles.json
  def create
    @application = current_user.owned_applications.find params[:role][:application]
    @role = @application.roles.new(params[:role])

    respond_to do |format|
      if @role.save
        format.html { redirect_to :back, notice: 'Role was successfully created.' }
        format.json { render json: @role, status: :created, location: @role }
      else
        format.html { render action: "new" }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /roles/1
  # PUT /roles/1.json
  def update
    @application = current_user.owned_applications.find params[:role][:application]
    @role = @application.roles.find(params[:id])
    params[:role].delete :application

    respond_to do |format|
      if @role.update_attributes(params[:role])
        format.html { redirect_to application_path(@application), notice: 'Role was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role = Role.find(params[:id])
    @role.destroy

    respond_to do |format|
      format.html { redirect_to :back, alert: "Role deleted" }
      format.json { head :no_content }
    end
  end
end
