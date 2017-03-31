FactoryGirl.define do
  factory :note do
    text "MyText"
    association :user
  end
end
