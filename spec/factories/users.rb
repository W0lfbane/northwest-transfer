FactoryGirl.define do
    factory :user do
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        phone { Faker::PhoneNumber.phone_number }
        email { Faker::Internet.email }
        password "password"
        password_confirmation "password"

        factory :admin do
            after(:create) { |user| user.add_role(:admin) }
        end
    end
end
