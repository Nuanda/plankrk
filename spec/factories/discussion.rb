FactoryGirl.define do
  factory :discussion do
    title { Faker::Lorem.sentence }
    fid { Faker::Number.number(4) }
    author
  end
end
