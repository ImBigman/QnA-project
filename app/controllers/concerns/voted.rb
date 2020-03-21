module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[positive_vote negative_vote]
  end

  def positive_vote
    authorize! :positive_vote, @votable
    vote(1) if acceptance_score <= 0
  end

  def negative_vote
    authorize! :negative_vote, @votable
    vote(-1) if acceptance_score >= 0
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def vote(number)
    @votable.votes.create(score: number, user: current_user)
    render json: { id: @votable.id, type: votable_type(@votable), rating: @votable.rating }
  end

  def votable_type(obj)
    obj.class.name.downcase
  end

  def acceptance_score
    votes = @votable.votes.where(user_id: current_user.id)
    votes.sum(:score)
  end
end

