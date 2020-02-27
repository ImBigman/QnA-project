class Answer < ApplicationRecord
  include Linkable

  default_scope { order(best: :desc).order(:created_at) }

  belongs_to :question
  belongs_to :user
  has_many_attached :files

  validates :body, presence: true, length: { minimum: 10 }

  def up_to_best!
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end
end
