FactoryGirl.define do
  factory :task do
    name 'test'
    description 'test'
    notes 'test'
    resource_state 'pending'
    association :project
  end
end
