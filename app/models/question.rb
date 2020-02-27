class Question < ApplicationRecord
  include Linkable

  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true, length: { minimum: 10 }
end
