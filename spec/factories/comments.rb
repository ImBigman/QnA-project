FactoryBot.define do
  factory :comment do
    body
    commentable { nil }
    user_id { nil }

    trait :invalid do
      body { '123456789'}
    end
  end
end
