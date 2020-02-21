FactoryBot.define do
  factory :answer do
    body { "This is test answer for some question" }
    user_id { nil }
    question { nil }

    trait :invalid do
      body { nil }
      question { nil }
    end

    trait :with_files do
      file1 =  Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'feature_helpers.rb'), 'file/rb')
      file2 =  Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'controller_helpers.rb'), 'file/rb')
      files { [file1, file2] }
    end
  end
end
