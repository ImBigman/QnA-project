FactoryBot.define do
  factory :answer do
    body { "This is test answer for some question" }
    question { nil }

    trait :invalid do
      body { nil }
      question { nil }
    end
  end
end
