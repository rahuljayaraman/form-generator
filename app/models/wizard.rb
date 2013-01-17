require 'active_support/all'
class Wizard
  delegate :raw, :edit_source_path, :content_tag, :link_to, to: :@view

  def initialize params, view_context = nil
    @params = params
    @databases = params[:wizard][:databases] rescue ""
    @view = view_context
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
    @databases 
  end

  def render_progress
    if @databases 
      source_tags = ""
      list_databases.each do |source|
        source_tags += content_tag(:li, link_to(source.source_name, edit_source_path(source, wizard: {databases: @databases})))
      end
      inner_content = content_tag(:h3, "Wizard Progress") +
        content_tag(:h5, "Databases created: " + count_databases.to_s) +
        raw(source_tags)
      content_tag(:div, inner_content, class: "well span-2 pull-right") 
    end
  end
end
