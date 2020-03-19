FactoryBot.define do
  sequence :name do |n|
    "Best answer reward ##{n}"
  end

  factory :reward do
    name
    question
    user { nil }

    trait :with_image do
      image { Rack::Test::UploadedFile.new('app/assets/images/cup-icon.png') }
    end
  end
end
