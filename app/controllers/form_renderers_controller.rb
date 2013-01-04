class FormRenderersController < ApplicationController

  before_filter :initialize_model

  def new
    @object = @model.new
    @attributes = @form.source_attributes
    @available_source_attributes = @source.source_attributes
    @available_has_manies = @source.has_manies.map(&:source_attributes).inject([]){|initial, val| initial + val}
    @available_belongs_tos = @source.belongs_tos.map(&:source_attributes).inject([]){|initial, val| initial + val}
  end

  def index
    @data = current_user.send(@model.collection_name)
    @attributes = @form.source_attributes.map(&:field_name)
    @attributes += ['Created At', 'Updated At']
  end

  def show
    @object = current_user.send(@model.collection_name).find(params[:id])
    @attributes = @object.attributes.except "_id"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @object }
    end
  end

  # GET /users/1/edit
  def edit
    @object = current_user.send(@model.collection_name).find(params[:id])
    @attributes = @form.source_attributes
    @available_source_attributes = @source.source_attributes
    @available_has_manies = @source.has_manies.map(&:source_attributes).inject([]){|initial, val| initial + val}
    @available_belongs_tos = @source.belongs_tos.map(&:source_attributes).inject([]){|initial, val| initial + val}
  end

  # POST /users
  # POST /users.json
  def create
    @object = current_user.send(@model.collection_name).new(params[@model.name.underscore])
    if @object.save
      redirect_to form_renderer_path(@object, form: @form.id), notice: "Entry to #{@form.form_name} saved."
    else
      @attributes = @form.source_attributes
      render action: "new" 
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @object = current_user.send(@model.collection_name).find(params[:id])
    @attributes = @object.attributes.except "_id"

    if @object.update_attributes(params[@model.name.underscore])
      redirect_to form_renderer_path(@object, form: @form.id), notice: "Entry to #{@form.form_name} updated."
    else
      @attributes = @form.source_attributes
      render action: "edit" 
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @object = current_user.send(@model.collection_name).find(params[:id])
    @object.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  private

  def initialize_model
    @form = Form.find(params[:form])
    @source = @form.source
    @model = @source.initialize_dynamic_model
    has_manies = @source.has_manies.map(&:initialize_dynamic_model)
    belongs_tos = @source.belongs_tos.map(&:initialize_dynamic_model)
    associated_models = (has_manies + belongs_tos) << @model
    User.define_relationships associated_models
  end
end
