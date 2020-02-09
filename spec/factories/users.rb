FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }

    trait :invalid do
      password_confirmation { '123456711' }
    end
  end
end
