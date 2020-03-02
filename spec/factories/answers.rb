FactoryBot.define do
  sequence :body do |n|
    "This is test answer ##{n} for some question"
  end

  factory :answer do
    body
    user_id { nil }
    question { nil }
    best { false }
    vote_score { 0 }

    trait :invalid do
      body { nil }
      question { nil }
    end

    trait :with_files do
      file1 =  Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'feature_helpers.rb'), 'file/rb')
      file2 =  Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'controller_helpers.rb'), 'file/rb')
      files { [file1, file2] }
    end

    trait :with_links do
      after(:build) do |answer|
        answer.links = [
          FactoryBot.create(:link, name: 'First', url: 'https://gist.github.com/ImBigman/8ca778b06a47e698bdbbb0b149f8dbdf', linkable: answer),
          FactoryBot.create(:link, name: 'Second', url: 'https://google.ru', linkable: answer)
        ]
      end
    end
  end
end
