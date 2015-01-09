FactoryGirl.define do
  factory :comment do
    content { Faker::Lorem.paragraph }
    author
    discussion
  end
end
