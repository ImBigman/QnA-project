class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def owner?(user)
    author_id == user.id
  end
end
