class FormsController < ApplicationController

  def index
    @forms = current_user.forms
  end
    
  def new
    if @source = Source.find(params[:source])
      @form = current_user.forms.new
      @available_source_attributes = @source.source_attributes
      @available_many_manies = @source.habtms.map(&:source_attributes).inject([]){|initial, val| initial + val}
      @available_belongs_tos = @source.belongs_tos.map(&:source_attributes).inject([]){|initial, val| initial + val}
    end
  end

  def edit
    @form = current_user.forms.find(params[:id])
    @source = @form.source
    @source_attributes = @source.source_attributes
    @related_many_manies = @source.habtms.map(&:source_attributes).inject([]){|initial, val| initial + val}
    @related_belongs_tos = @source.belongs_tos.map(&:source_attributes).inject([]){|initial, val| initial + val}
    @available_source_attributes = @source_attributes - @form.source_attributes
    @available_many_manies = @related_many_manies - @form.source_attributes
    @available_belongs_tos = @related_belongs_tos - @form.source_attributes
    @source_attribute_ids = @form.source_attributes.map(&:id)
  end

  def show
    @form = current_user.forms.find(params[:id])
  end

  def create
    @form = current_user.forms.new params[:form]
    if @form.save
      redirect_to user_path(current_user), notice: "Form saved"
    else
      render :new
    end
  end

  def update
    @form = current_user.forms.find(params[:id])

    # This line makes me want to puke. Unfortunately, find_or_initialize may not work for nested_attributes. Will wrap this in a transaction later.
    @form.form_attributes.destroy_all
    if @form.update_attributes(params[:form])
      redirect_to user_path(current_user), notice: 'Form was successfully updated.' 
    else
      render action: "edit" 
    end
  end

  def destroy
    @form = current_user.forms.find(params[:id])
    @form.destroy
    redirect_to user_path(current_user), alert: "Form deleted"
  end

end
