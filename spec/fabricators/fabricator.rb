require 'faker'

Fabricator :user do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  password 'foobar'
  salt { "asdasdastr4325234324sdfds" }
  crypted_password { Sorcery::CryptoProviders::BCrypt.encrypt("foobar", 
                                                              "asdasdastr4325234324sdfds") }
  transient :user_with_attr

  after_create { |user| Fabricate(:source, user: user) }
end

Fabricator :source do
  set_name { Faker::Lorem.word }
  transient :attr
  user

  after_create { |source| Fabricate(:model_attribute, source: source) }
  after_build { |source| Fabricate.build(:model_attribute, source: source) }
end

Fabricator :model_attribute do
  field_name { Faker::Lorem.word }
  field_type  { "Number" }
  source
end
