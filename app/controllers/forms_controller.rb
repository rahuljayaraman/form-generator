class FormsController < ApplicationController

  def index
    @forms = current_user.forms
  end
    
  def new
    if @source = Source.find(params[:source])
      @form = current_user.forms.new
      @source_attributes = @source.source_attributes
      @related_has_manies = @source.has_manies
      @related_belongs_tos = @source.belongs_tos
    end
  end

  def edit
    if @source = Source.find(params[:source])
      @form = current_user.forms.find(params[:id])
      @source_attributes = @source.source_attributes
      @related_has_manies = @source.has_manies
      @related_belongs_tos = @source.belongs_tos
    end
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

    respond_to do |format|
      if @form.update_attributes(params[:form])
        format.html { redirect_to @form, notice: 'Form was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @form = current_user.forms.find(params[:id])
    @form.destroy
    redirect_to user_path(current_user), alert: "Form deleted"
  end

end
