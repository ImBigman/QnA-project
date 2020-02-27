FactoryBot.define do
  sequence :title do |n|
    "Its test question ##{n} title"
  end

  factory :question do
    title
    body { 'Its test question body' }
    user_id { nil }

    trait :invalid do
      title { nil }
    end

    trait :with_files do
      file1 =  Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'feature_helpers.rb'), 'file/rb')
      file2 =  Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'controller_helpers.rb'), 'file/rb')
      files { [file1, file2] }
    end

    trait :with_links do
      after(:build) do |question|
        question.links = [
          FactoryBot.create(:link, name: 'First', url: 'https://gist.github.com/ImBigman/8ca778b06a47e698bdbbb0b149f8dbdf', linkable: question),
          FactoryBot.create(:link, name: 'Second', url: 'https://google.ru', linkable: question)
        ]
      end
    end
  end
end
