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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @attributes }
      format.js
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
    @wizard = Wizard.new params, view_context
    render template: "wizard/step1"
  end

  # POST /sources
  # POST /sources.json
  def create
    @source = current_user.sources.new(params[:source])
    @wizard = Wizard.new params[:source], view_context

      if @source.save
        if @wizard.active?
          @wizard.append_database @source.id
          redirect_to wizard_step1_path(wizard: {databases: @wizard.url}), notice: 'Database was successfully saved.'
        else
         redirect_to user_path(current_user), notice: 'Database was successfully saved.'
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

      if @source.update_attributes(params[:source])
        if @wizard.active?
          redirect_to wizard_step1_path(wizard: {databases: @wizard.url}), notice: 'Database was successfully saved.'
        else
          redirect_to user_path(current_user), notice: 'Database was successfully saved.'
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
      format.html { redirect_to user_path(current_user), notice: "Database was deleted!" }
      format.json { head :no_content }
    end
  end
end
