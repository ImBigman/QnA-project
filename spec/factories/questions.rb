FactoryBot.define do
  sequence :title do |n|
    "Its test question ##{n} title"
  end

  factory :question do
    title
    body { "Its test question body" }
    user_id { nil }

    trait :invalid do
      title { nil }
    end

    trait :with_files do
      file1 =  Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'feature_helpers.rb'), 'file/rb')
      file2 =  Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'controller_helpers.rb'), 'file/rb')
      files { [file1, file2] }
    end
  end
end
