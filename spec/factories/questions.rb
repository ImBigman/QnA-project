FactoryBot.define do
  sequence :title do |n|
    "Its test question ##{n} title"
  end

  factory :question do
    title
    body { "Its test question body" }
    author_id { nil }
    trait :invalid do
      title { nil }
    end
  end
end
