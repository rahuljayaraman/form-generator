module ApplicationHelper
  def set_application_parameters
    content_for :app_url do 
      application_path @application unless @application.nil? 
    end 
    content_for :app_name do
      @application.application_name.camelize unless @application.nil?
    end
  end
end
