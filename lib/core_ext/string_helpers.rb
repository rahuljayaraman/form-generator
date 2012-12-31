module Conversions
  def convert_attribute str
    str.gsub(/[^0-9a-zA-Z]/i, '').underscore
  end
end

class String
  include Conversions
  def not_loaded
    false if eval(self).exists?
  rescue NameError
    true
  rescue NoMethodError
   # This would be applicable for reserved or nil classes i presume. I don't expect this usecase to come up though.
    true
  end
  
  def attribute
    convert_attribute self
  end
end

