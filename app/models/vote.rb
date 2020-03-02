class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true

  validates :score, presence: true
end
