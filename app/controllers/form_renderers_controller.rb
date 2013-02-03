class FormRenderersController < ApplicationController

  before_filter :authorize
  before_filter :initialize_model

  def new
    @object = @model.new
    @attributes = @form.source_attributes
    @available_source_attributes = @relationship.direct_attributes
    @available_many_manies = @relationship.has_many_attributes
    @available_belongs_tos = @relationship.belongs_to_attributes
  end

  def index
    @attributes = @form.source_attributes
    add = Struct.new(:id, :field_name)
    @attributes += [add.new(1, 'Created At'), add.new(2, 'Updated At')]
    @user_attributes = ['Name', 'Email']
    @data = @model.all
    @direct_attributes = @relationship.direct_attributes
    @belongs_to_attributes = @relationship.belongs_to_attributes
    @habtm_attributes = @relationship.habtm_attributes
    @has_many_attributes = @relationship.has_many_attributes
  end

  def show
    if @application && current_user.owns_application(@application)
      @object = @model.find(params[:id])
    else
      @object = current_user.send(@model.collection_name).find(params[:id])
    end
    @attributes = @object.attributes.except "_id"
    @all_my_attributes = @form.source_attributes
    @available_many_manies = @relationship.habtm_attributes
    @available_belongs_tos = @relationship.belongs_to_attributes


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @object }
    end
  end

  # GET /users/1/edit
  def edit
    if @application && current_user.owns_application(@application)
      @object = @model.find(params[:id])
    else
      @object = current_user.send(@model.collection_name).find(params[:id])
    end
    @attributes = @form.source_attributes
    @available_source_attributes = @relationship.direct_attributes
    @available_many_manies = @relationship.habtm_attributes
    @available_belongs_tos = @relationship.belongs_to_attributes
  end

  # POST /users
  # POST /users.json
  def create
    @object = current_user.send(@model.collection_name).new(params[@model.name.underscore])
    if @object.save
      redirect_to form_renderer_path(@object, form: @form.id, application: @application.try(:id)), notice: "Entry to #{@form.form_name} saved."
    else
      @attributes = @form.source_attributes
      @available_source_attributes = @relationship.direct_attributes
      @available_many_manies = @relationship.habtm_attributes
      @available_belongs_tos = @relationship.belongs_to_attributes
      render action: "new" 
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @object = @model.find(params[:id])
    if @application && current_user.owns_application(@application)
      @object.user_id = @object.user_id
    else
      @object.user_id = current_user.id
    end
    @attributes = @object.attributes.except "_id"

    if @object.update_attributes(params[@model.name.underscore])
      redirect_to form_renderer_path(@object, form: @form.id, application: @application.try(:id)), notice: "Entry to #{@form.form_name} updated."
    else
      @attributes = @form.source_attributes
      render action: "edit" 
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @application && current_user.owns_application(@application)
      @object = @model.find(params[:id])
    else
      @object = current_user.send(@model.collection_name).find(params[:id])
    end
    @object.destroy

    respond_to do |format|
      format.html { redirect_to application_path(@application), alert: "Entry deleted!" }
      format.json { head :no_content }
    end
  end

  private

  def initialize_model
    if params[:application] && !params[:application].blank?
      @application = Application.find params[:application]
    end
    @form = Form.find(params[:form])
    @relationship = Relationship.new @form
    @relationship.define!
    @model = @relationship.get_model
  end
end
