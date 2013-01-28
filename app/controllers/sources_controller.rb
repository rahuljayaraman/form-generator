class SourcesController < ApplicationController
  # GET /sources
  # GET /sources.json
  def index
    @sources = current_user.sources.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sources }
    end
  end

  # GET /sources/1
  # GET /sources/1.json
  def show
    @source = Source.find(params[:id])
    @attributes = @source.source_attributes
    @selected_source = @source
    @report = current_user.reports.new
    @wizard = Wizard.new params, view_context

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @attributes }
      format.js { render "sources/render_for_form", source_attributes: @attributes, data_type: params[:data_type] if params[:attributes] }
    end
  end

  # GET /sources/new
  # GET /sources/new.json
  def new
    @source = Source.new
    @sources = current_user.sources

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @source }
    end
  end

  # GET /sources/1/edit
  def edit
    @source = Source.find(params[:id])
    @sources = current_user.sources.not_in(_id: [@source.id])
    @edit = true
    @wizard = Wizard.new params, view_context
    respond_to do |format|
      format.html { render template: "wizard/step1" if @wizard.active? }
      format.js
    end
  end

  # POST /sources
  # POST /sources.json
  def create
    @source = current_user.sources.new(params[:source])
    @wizard = Wizard.new params[:source], view_context

      if @source.save
        if @wizard.active?
          @wizard.append_database @source.id
          redirect_to wizard_step1_path(@wizard.parameters), notice: 'Register was successfully saved.'
        else
         redirect_to user_path(current_user), notice: 'Register was successfully saved.'
        end
      else
        render action: "new" 
      end
  end

  # PUT /sources/1
  # PUT /sources/1.json
  def update
    @source = Source.find(params[:id])
    @wizard = Wizard.new params[:source], view_context
    if params[:source][:disjoint_relationship]
      @wizard.mark_relationships
    end

      if @source.update_attributes(params[:source])
        if @wizard.active? && params[:source][:disjoint_relationship]
          redirect_to wizard_step2_path(@wizard.parameters), notice: 'Relationship was successfully saved.'
        elsif @wizard.active?
          redirect_to wizard_step1_path(@wizard.parameters), notice: 'Register was successfully saved.'
        else
          redirect_to user_path(current_user), notice: 'Register was successfully saved.'
        end
      else
        render action: "edit" 
      end
  end

  # DELETE /sources/1
  # DELETE /sources/1.json
  def destroy
    @source = Source.find(params[:id])
    @source.destroy

    respond_to do |format|
      format.html { redirect_to user_path(current_user), notice: "Register was deleted!" }
      format.json { head :no_content }
    end
  end

  def fetch_attributes
    @source = Source.find(params[:id])
    @source_attributes = @source.source_attributes
    @data_type = params[:data_type]

    respond_to do |format|
      format.js
    end
  end

  def import
    @wizard = Wizard.new params, view_context
    if params[:import]
      unless params[:file]
        redirect_to new_source_path, alert: "You forgot to attach a master file."
        return
      end
      if params[:source_name].present? && !params[:source_name].blank?
        name = params[:source_name]
      elsif params[:source_name].present?
        name = params[:file].original_filename
      else
        name = ""
      end
      begin
        source_header = Source.build_headers(name, params[:file], current_user)
      rescue Source::NoHeader
        @source = Source.new
        flash.now[:alert] = "You seem to have a blank entry in your headers. Please correct this & try again."
        render :new
        return
      end

      @source = source_header[:source]

      if params[:import] == "header"
        if @wizard.active?
          render 'wizard/step1' 
        else
          render :new 
        end
        return
      else
        #parse xls master
        unless @source.save
          flash.now[:alert] = "Please try and upload the masters again or click on save to create headers only."
          render :new
          return
        end
        @data = Source.import_data(@source, source_header[:header], source_header[:spreadsheet], current_user) 
        if @data
          if @wizard.active?
            @wizard.append_database @source.id
            redirect_to wizard_step1_path(@wizard.parameters), notice: 'Master has been imported!'
          else
            redirect_to user_path(current_user), notice: "Master has been Imported!"
          end
        else
          @source.destroy
          @source = Source.new
          flash.now[:alert] = "There was something wrong with the file you uploaded. Please check the file & try again."
          render action: "new" 
        end
      end
    end
  end
end
