class Answer < ApplicationRecord
  belongs_to :question

  validates :body, presence: true, length: { minimum: 10 }
  belongs_to :author, class_name: 'User'
end
