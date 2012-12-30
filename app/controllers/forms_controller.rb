class FormsController < ApplicationController

  before_filter :initialize_model

  def new
    @object = @model.new
    @attributes = @source.source_attributes
  end

  def index
    @objects = @model.all
  end

  def show
    @object = @model.find(params[:id])
    @attributes = @object.attributes.except "_id"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @object }
    end
  end

  # GET /users/1/edit
  def edit
    @object = @model.find(params[:id])
    @attributes = @source.source_attributes
  end

  # POST /users
  # POST /users.json
  def create
    @object = @model.new(params[@model.name.underscore])
    if @object.save
      redirect_to form_path(@object, source: params[:source]), notice: "#{@source.source_name} saved."
    else
      render action: "new" 
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @object = @model.find(params[:id])
    @attributes = @object.attributes.except "_id"

    if @object.update_attributes(params[@model.name.underscore])
      redirect_to form_path(@object, source: @source.id), notice: "#{@source.source_name} updated."
    else
      render action: "edit" 
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

  def initialize_model
    @source = Source.find(params[:source])
    @model = @source.initialize_dynamic_model
  end
end
