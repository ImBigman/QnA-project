class Answer < ApplicationRecord
  include Linkable
  include Attachable
  include Votable

  default_scope { order(best: :desc).order(:created_at) }

  has_many :comments, dependent: :destroy, as: :commentable

  belongs_to :question, touch: true
  belongs_to :user

  validates :body, presence: true, length: { minimum: 10 }

  after_create :send_email

  def up_to_best!
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end

  private

  def send_email
    AnswersSubscriptionsJob.perform_later(question, self) if question.subscriptions.exists?
  end
end
