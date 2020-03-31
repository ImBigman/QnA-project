class Question < ApplicationRecord
  include Linkable
  include Attachable
  include Votable

  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy, as: :commentable
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user, dependent: :destroy
  has_one :reward, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true, length: { minimum: 10 }

  after_create :create_subscription

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end

  def subscription(user)
    subscriptions.find_by(user: user)
  end

  private

  def create_subscription
    subscriptions.create(user_id: user_id)
  end
end
