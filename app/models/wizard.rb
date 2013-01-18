require 'active_support/all'
#Design: params[:wizard] [:databases, :relationships, :forms] should be part of the URL to render progress. Seperate methods to add :forms/:databases & toggle :relationships
class Wizard
  delegate :raw, :edit_source_path, :content_tag, :link_to, :wizard_step2_path, to: :@view
  attr_accessor :databases, :relationships, :forms

  def initialize params, view_context = nil
    @params = params
    @databases = params[:wizard][:databases] rescue ""
    @relationships = params[:wizard][:relationships] rescue "false"
    @forms = params[:wizard][:forms] rescue ""
    @view = view_context
    @url = ""
  end 

  def split_databases
    @databases.split(",")
  end

  def list_databases
    split_databases.reject(&:blank?).map{|d| find_source d}
  end

  def count_databases
    split_databases.count  
  end

  def find_source id
    Source.find id
  end

  def active?
    !@databases.nil?
  end

  def append_database id
    @databases = (split_databases << id).join(",")
  end

  def url
    @url = @databases
  end

  def mark_relationships
    @relationships = "true"
  end

  def render_progress
    if @databases 
      source_tags = ""
      list_databases.each do |source|
        source_tags += content_tag(:li, link_to(source.source_name, edit_source_path(source, wizard: {databases: @databases, relationships: @relationships})))
      end
      relationship_header = content_tag(:h5, "Relationships")
      relationships = relationship_header + content_tag(:li,link_to("Completed", wizard_step2_path(wizard: {databases: @databases, relationships: @relationships}))) if eval(@relationships)
      inner_content = content_tag(:h3, "Wizard Progress") +
        content_tag(:h5, "Databases created: " + count_databases.to_s) +
        raw(source_tags) + relationships
      content_tag(:div, inner_content, class: "well span-2 pull-right")
    end
  end
end
