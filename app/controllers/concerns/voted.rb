module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[positive_vote negative_vote]
  end

  def positive_vote
    if acceptance_score <= 0
      vote(1)
    else
      render json: { error: 'You have already voted' }, status: 422
    end
  end

  def negative_vote
    if acceptance_score >= 0
      vote(-1)
    else
      render json: { error: 'You have already voted' }, status: 422
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def vote(number)
    if current_user.owner?(@votable)
      render json: { error: 'You cannot vote for yourself' }, status: 422
    else
      @votable.votes.create(score: number, user_id: current_user.id)
      render json: @votable.recount
    end
  end

  def acceptance_score
    votes = @votable.votes.where(user_id: current_user.id)
    votes.map(&:score).sum
  end
end

