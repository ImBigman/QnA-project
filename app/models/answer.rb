class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 10 }

  scope :by_worth, -> { where(best: 'true') }

  def up_to_best
    update(best: 'true')
  end

  def usual
    update(best: 'false')
  end

  def best?
    best == 'true'
  end
end
