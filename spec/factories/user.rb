FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    provider :facebook
  end
end