FactoryGirl.define do
  factory :group do
    title { Faker::University.name }
    description { Faker::Lorem.sentence }
  end
end
