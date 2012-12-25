class FormsController < ApplicationController

  before_filter :set_model

  def new
    @object = @model.new
    @attributes = @source.source_attributes
  end

  def index
    @objects = @model.all
  end

  def show
    @object = @model.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @object }
    end
  end

  # GET /users/1/edit
  def edit
    @object = @model.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @object = @model.new(params[:user])
    if @object.save
      redirect_to user_path(current_user), notice: "#{@source.set_name} saved."
    else
      render action: "new" 
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @object = @model.find(params[:id])

    respond_to do |format|
      if @object.update_attributes(params[:user])
        format.html { redirect_to user_path(current_user), notice: "#{@source.set_name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @object.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @object = @model.find(params[:id])
    @object.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  private

  def set_model
    @source = Source.find(params[:format])
    @model = @source.initialize_set
  end
end
