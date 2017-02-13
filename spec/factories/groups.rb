FactoryGirl.define do
  factory :group do
    name { Faker::University.name }
    description { Faker::Lorem.sentence }
  end
end
