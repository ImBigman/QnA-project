class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  def owner?(resource)
    resource.user == self
    #TODO fix this method
  end
end

