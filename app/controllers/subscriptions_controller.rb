class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create index show]
  before_action :set_subscription, only: :destroy

  authorize_resource

  def create
    @question.subscriptions.create(user_id: current_user.id)
  end

  def destroy
    @question = @subscription.question
    @subscription.destroy
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end
end

