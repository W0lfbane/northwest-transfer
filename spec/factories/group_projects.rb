FactoryGirl.define do
  factory :group_project do
    association :group
    association :project
  end
end