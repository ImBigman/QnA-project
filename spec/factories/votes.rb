FactoryBot.define do
  factory :vote do
    score { 0 }
    votable { nil }
    user_id { nil }
  end
end
