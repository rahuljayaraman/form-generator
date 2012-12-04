require 'faker'

FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    email Faker::Internet.email
    password 'foobar'
    password_confirmation 'foobar'
  end
   
  factory :source do
    set_name Faker::Lorem.word
    user
  end
end
