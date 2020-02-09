class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true, length: { minimum: 10 }
  belongs_to :author, class_name: 'User'
end
