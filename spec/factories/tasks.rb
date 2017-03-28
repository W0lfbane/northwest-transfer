FactoryGirl.define do
  factory :task do
    name 'test'
    description 'test'
    association :project
  end
end
