FactoryBot.define do
  factory :link do
    linkable { nil }
    name { 'Link' }
    url { 'https://' }
  end
end
