FactoryGirl.define do
  factory :user do
    user_name { Faker::Name.name }
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
  end
end
