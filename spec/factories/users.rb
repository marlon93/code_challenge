FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "passworD123*" }
    password_confirmation { "passworD123*" }
  end
end
