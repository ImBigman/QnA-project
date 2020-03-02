module Votabled
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[positive_vote negative_vote recount vote acceptance_score]
  end

  def positive_vote
    if acceptance_score <= 0
      vote(1)
    else
      respond_to do |format|
        format.json { render json: 'You have already voted', status: 422 }
      end
    end
  end

  def negative_vote
    if acceptance_score >= 0
      vote(-1)
    else
      respond_to do |format|
        format.json { render json: 'You have already voted', status: 422 }
      end
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
      respond_to do |format|
        format.json { render json: 'You cannot vote for yourself', status: 422 }
      end
    else
      @vote = @votable.votes.create(score: number, user_id: current_user.id)
      recount(@vote)
      respond_to do |format|
        format.json { render json: @votable.vote_score }
      end
    end
  end

  def recount(vote)
    current_score = @votable.vote_score
    new_score = vote.score
    @votable.vote_score = current_score + new_score
    @votable.save unless current_user.owner?(@votable)
  end

  def acceptance_score
    votes = @votable.votes.where(user_id: current_user.id)
    votes.map(&:score).sum
  end
end

