FactoryGirl.define do
    factory :user do
        first_name {Faker::Name}
        last_name {Faker::Name}
        phone "8888888888"
        email { Faker::Internet.email }
        password "password"
        password_confirmation "password"

        factory :admin do
            after(:create) { |user| user.add_role(:admin) }
        end
    end
end
