FactoryGirl.define do
  factory :project do
    title   'test'
    description 'test'
    start_date  DateTime.now
    completion_date DateTime.now + 2.hours # add two hour
    estimated_completion_date '2001-1-1'
    notes 'test'
    address '123 test street'
    city 'test city'
    state 'TE'
    postal '66666'
    resource_state 'pending'
  end
end