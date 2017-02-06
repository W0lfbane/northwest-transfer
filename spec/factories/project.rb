FactoryGirl.define do
  factory :project do
    title   'test'
    description 'test'
    start_date  '2001-1-1'
    completion_date '2001-1-1'
    estimated_completion_date '2001-1-1'
    notes 'test'
    location 'test'
    resource_state 'pending'
  end
end