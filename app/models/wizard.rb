require 'active_support/all'
#Design: params[:wizard] [:databases, :relationships, :forms] should be part of the URL to render progress. Seperate methods to add :forms/:databases & toggle :relationships
class Wizard
  delegate :raw, :edit_source_path, :edit_form_path, :content_tag, :link_to, :wizard_step2_path, :edit_report_path, to: :@view
  attr_accessor :databases, :relationships, :forms, :reports

  def initialize params, view_context = nil
    @params = params
    @databases = params[:wizard][:databases] rescue ""
    @relationships = params[:wizard][:relationships] rescue "false"
    @forms = params[:wizard][:forms] rescue ""
    @reports = params[:wizard][:reports] rescue ""
    @view = view_context
    @wizard = params[:wizard][:wizard] rescue false
    @url = ""
  end 

  ["forms","databases", "reports"].each do |entity|
    define_method "split_#{entity}" do
      eval("@#{entity}").split(",") 
    end

    define_method "list_#{entity}" do
      eval("split_#{entity}").reject(&:blank?).map do |d| 
        eval("find_#{entity}('#{d}')")
      end
    end

    define_method "count_#{entity}" do
      eval("split_#{entity}").count  
    end
  end

  def find_databases id
    Source.find id
  end

  def find_forms id
    Form.find id
  end

  def find_reports id
    Report.find id
  end

  def active?
    @wizard
  end

  def initialize_wizard
    @wizard = true
  end

  def append_database id
    @databases = (split_databases << id).join(",")
  end

  def append_form id
    @forms = (split_forms << id).join(",")
  end

  def append_report id
    @reports = (split_reports << id).join(",")
  end

  def parameters
    { "wizard" => { "databases" => @databases, "relationships" => @relationships, "forms" => @forms, "reports" => @reports, "wizard" => @wizard } }
  end

  def mark_relationships
    @relationships = "true"
  end

  def render_progress
    if @databases 
      source_tags = ""
      form_tags = ""
      report_tags = ""
      list_databases.each do |source|
        source_tags += content_tag(:li, link_to(source.source_name, edit_source_path(source, parameters)))
      end
      list_forms.each do |source|
        form_tags += content_tag(:li, link_to(source.form_name, edit_form_path(source, parameters)))
      end
      list_reports.each do |source|
        report_tags += content_tag(:li, link_to(source.report_name, edit_report_path(source, parameters)))
      end
      relationship_header = content_tag(:h5, "Relationships")
      relationships = relationship_header + content_tag(:li,link_to("Completed", wizard_step2_path(parameters))) if eval(@relationships)
      inner_content = content_tag(:h3, "Wizard Progress") +
        content_tag(:h5, "Databases created: " + count_databases.to_s) +
        raw(source_tags) + relationships + content_tag(:h5, "Forms created: " + count_forms.to_s) + raw(form_tags) + content_tag(:h5, "Reports created: " + count_reports.to_s) + raw(report_tags)

      content_tag(:div, inner_content, class: "well span-2 pull-right")
    end
  end
end
