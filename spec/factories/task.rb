FactoryGirl.define do
  factory :task do
    name 'test'
    description 'test'
    notes 'test'
    association :project
  end
end
