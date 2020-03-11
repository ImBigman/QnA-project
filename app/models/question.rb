class Question < ApplicationRecord
  include Linkable
  include Attachable
  include Votable

  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy, as: :commentable
  has_one :reward, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true, length: { minimum: 10 }
end
