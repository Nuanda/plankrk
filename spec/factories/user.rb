FactoryGirl.define do
  factory :user, aliases: [:author] do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    provider :facebook
  end
end