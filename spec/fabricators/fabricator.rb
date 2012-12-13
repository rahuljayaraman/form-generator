require 'faker'

Fabricator :user do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  password 'foobar'
  password_confirmation 'foobar'
  transient :user_with_attr
  # after_create { |user| Fabricate(:source, user: user, attr: true) if user[:user_with_attr] }
   after_create { |user| Fabricate(:source, user: user) }
end

Fabricator :source do
  set_name { Faker::Lorem.word }
  transient :attr
  user
  # after_create { |source| Fabricate(:model_attribute, source: source) if source[:attr] }
   after_create { |source| Fabricate(:model_attribute, source: source) }

end

Fabricator :model_attribute do
  field_name { Faker::Lorem.word }
  field_type  { Source.mapping.keys.shuffle.first }
  source
end
