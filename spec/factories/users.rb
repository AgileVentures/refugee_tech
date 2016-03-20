FactoryGirl.define do
  factory :user do
    user_name { Faker::Name.name }
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    gender 'male'
    latitude 44.960562
    longitude 13.123123
    mentor false
    private false
  end
end
