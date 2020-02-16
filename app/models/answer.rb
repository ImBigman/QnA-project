class Answer < ApplicationRecord
  default_scope { order(best: :desc).order(:created_at) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 10 }

  scope :by_worth, -> { where(best: true) }

  def up_to_best
    question.answers.by_worth.each { |answer| answer.update!(best: false) }
    update!(best: true)
  end
end
