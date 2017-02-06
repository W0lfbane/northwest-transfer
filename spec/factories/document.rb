FactoryGirl.define do
  factory :document do
    title   'test'
    association :project
  end
end