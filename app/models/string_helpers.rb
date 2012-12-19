class String
  def not_loaded
    false if eval(self).exists?
  rescue NameError
    true
  rescue NoMethodError
   # This would be applicable for reserved or nil classes i presume. I don't expect this usecase to come up though.
    true
  end

  def attribute
    self.gsub(' ','').underscore
  end
end
