class Permission
  def initialize user, params
    @user = user
    @params = params
  end

  def allow?
    type = find_type
    if type == "form"
      validate_form @params[:form]
    else
      validate_report @params[:id]
    end 
  end

  def find_type
    if @params[:form]
      "form"
    else
      "report"
    end
  end

  def validate_form form_id
    applications =  @user.used_applications
    roles = applications.map(&:roles).inject([]){|initial, sum| initial + sum}
    forms = roles.map(&:forms).inject([]){|initial, sum| initial + sum}
    form = Form.find(form_id)
    #Allow owner or if permission given
    @user.forms.include?(form) || forms.include?(form)
  end

  def validate_report report_id
    applications =  @user.used_applications
    roles = applications.map(&:roles).inject([]){|initial, sum| initial + sum}
    reports = roles.map(&:reports).inject([]){|initial, sum| initial + sum}
    report = Report.find(report_id)
    #Allow owner or if permission given
    @user.reports.include?(report) || reports.include?(report)
  end
end
