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
  source_name { Faker::Lorem.word }
  transient :attr
  user

  after_create { |source| Fabricate(:source_attribute, source: source) }
  after_build { |source| Fabricate.build(:source_attribute, source: source) }
end

Fabricator :source_attribute do
  field_name { Faker::Lorem.word }
  field_type  { "Number" }
  source
end
