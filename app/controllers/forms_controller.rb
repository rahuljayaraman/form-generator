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
    @available_sources = current_user.sources - [@source] - @source.habtms - @source.belongs_tos - @source.has_manies
    @wizard = Wizard.new params, view_context
    respond_to do |format|
      format.html # show.html.erb
      format.js
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
    @wizard = Wizard.new params, view_context
    @available_sources = current_user.sources - [@source] - @source.habtms - @source.belongs_tos - @source.has_manies
  end

  def show
    @form = current_user.forms.find(params[:id])
  end

  def create
    @wizard = Wizard.new params[:form], view_context
    @form = current_user.forms.new params[:form]
    if @form.save
      @source = @form.source
      @related_has_manies = @form.has_manies.map(&:source) - [@source]
      @related_belongs_tos = @form.belongs_tos.map(&:source) - [@source]
      @source.habtm_ids += @related_has_manies.map(&:id)
      @source.belongs_to_ids += @related_belongs_tos.map(&:id)
      @source.save
      if @wizard.active?
        @wizard.append_form @form.id
        redirect_to wizard_step3_path(@wizard.parameters), notice: 'Form was saved.'
      else
        redirect_to form_path(@form), notice: "Form saved"
      end
    else
      @source = @form.source
      @source_attributes = @source.source_attributes
      @related_many_manies = @source.habtms.map(&:source_attributes).inject([]){|initial, val| initial + val}
      @related_belongs_tos = @source.belongs_tos.map(&:source_attributes).inject([]){|initial, val| initial + val}
      @available_source_attributes = @source_attributes - @form.source_attributes
      @available_many_manies = @related_many_manies - @form.source_attributes
      @available_belongs_tos = @related_belongs_tos - @form.source_attributes
      @available_sources = current_user.sources - [@source] - @source.habtms - @source.belongs_tos - @source.has_manies
      @source_attribute_ids = @form.source_attributes.map(&:id)
      render :new
    end
  end

  def update
    @form = current_user.forms.find(params[:id])
    @wizard = Wizard.new params[:form], view_context

    # This line makes me want to puke. Unfortunately, find_or_initialize may not work for nested_attributes. Will wrap this in a transaction later.
    @form.form_attributes.destroy_all
    if @form.update_attributes(params[:form])
      @source = @form.source
      @related_has_manies = @form.has_manies.map(&:source) - [@source]
      @related_belongs_tos = @form.belongs_tos.map(&:source) - [@source]
      @source.habtm_ids += @related_has_manies.map(&:id)
      @source.belongs_to_ids += @related_belongs_tos.map(&:id)
      @source.save
      if @wizard.active?
        redirect_to wizard_step3_path(@wizard.parameters), notice: 'Form was Updated.'
      else
        redirect_to form_path(@form), notice: "Form Updated"
      end
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
