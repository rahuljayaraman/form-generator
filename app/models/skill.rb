class Skill
  include Mongoid::Document
  embedded_in :user

  field :skill_name
end
