FactoryGirl.define do
  factory :project do
    title "test title"
    description "test description"
    location "test location"
    start_date Time.now
    estimated_completion_date Time.now + 2.weeks
  end
end