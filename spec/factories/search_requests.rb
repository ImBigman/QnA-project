FactoryBot.define do
  factory :search_request do
    body { 'Its test search request body' }
    type { 'public' }
    user
  end
end
