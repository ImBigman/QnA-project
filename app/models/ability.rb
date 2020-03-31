# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :me, User, id: user.id
    can :other_users, User, id: user.id
    can :make_better, Answer, question: { user_id: user.id }
    can :create, [Answer, Question, Comment, Reward, Subscription]
    can %i[update destroy], [Answer, Question, Comment, Subscription], user_id: user.id
    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }
    can :destroy, Link, linkable: { user_id: user.id }
    can %i[positive_vote negative_vote], [Answer, Question] do |resource|
      resource.user_id != user.id
    end
  end

  def admin_abilities
    can :manage, :all
  end
end
