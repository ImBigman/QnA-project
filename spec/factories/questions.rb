FactoryBot.define do
  factory :question do
    title { "Its test question title" }
    body { "Its test question body" }

    trait :invalid do
      title { nil }
    end
  end
end
