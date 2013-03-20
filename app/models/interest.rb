class Interest
  include Mongoid::Document
  embedded_in :user

  field :interest_name
end
