class ReportsController < ApplicationController
  # GET /reports
  # GET /reports.json
  def index
    @reports = current_user.reports.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reports }
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = current_user.reports.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/new
  # GET /reports/new.json
  def new
    @report = current_user.reports.new
    @sources = current_user.sources

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/1/edit
  def edit
    @report = current_user.reports.find(params[:id])
    @selected_source = @report.source
    @wizard = Wizard.new(params, view_context)
    @edit = true
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = current_user.reports.new(params[:report])
    @wizard = Wizard.new(params[:report], view_context)

    if @report.save
      if @wizard.active?
        @wizard.append_report @report.id
        redirect_to wizard_step4_path(@wizard.parameters), notice: 'Report was successfully saved.'
      else
        redirect_to report_path(@report), notice: 'Report was successfully created.' 
      end
    else
      render action: "new" 
    end
  end

  # PUT /reports/1
  # PUT /reports/1.json
  def update
    @report = current_user.reports.find(params[:id])
    @wizard = Wizard.new(params[:report], view_context)

    if @report.update_attributes(params[:report])
      if @wizard.active?
        redirect_to wizard_step4_path(@wizard.parameters), notice: 'Report was successfully updated.'
      else
        redirect_to report_path(@report), notice: 'Report was successfully updated.' 
      end
    else
      render action: "edit" 
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report = current_user.reports.find(params[:id])
    @report.destroy

    respond_to do |format|
      format.html { redirect_to user_path(current_user), notice: "Report was deleted!" }
      format.json { head :no_content }
    end
  end

  def view_report
    @report = Report.find params[:id]
    @attributes = @report.source_attributes
    add = Struct.new(:field_name, :field_type, :id)
    @attributes += [add.new('Created At', 'Date & Time'), add.new('Updated At', 'Date & Time')]
    @user_attributes = @report.user_attributes.reject(&:blank?) if @report.user_attributes
    #Initialize related models
    @relationship = Relationship.new nil, @report.source
    @relationship.define!
    @model = @relationship.get_model
    @direct_attributes = @relationship.direct_attributes
    @belongs_to_attributes = @relationship.belongs_to_attributes
    @habtm_attributes = @relationship.habtm_attributes
    @has_many_attributes = @relationship.has_many_attributes

    if params[:search].present?
      begin
        @data = @report.search(params[:search])
      rescue SearchWithTire::NoIndex
        @data = @report.search(params[:search])
        flash.now[:alert] = "Sorry it took that long. We had to index all your data. Please try searching again. It will be much faster."
      rescue SearchWithTire::InvalidQuery
        @data = @model.paginate(per_page: 7, page: params[:page])
        flash.now[:alert] = "Invalid Search Query"
      end
    else
      @data = @model.paginate(per_page: 7, page: params[:page])
    end
    respond_to do |format|
      format.html
      format.xls
    end
  end
end
