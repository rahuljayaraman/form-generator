class String
  def not_loaded?
    false if eval(self).try(:wrap).exists?
  rescue NameError
    true
  end
end
