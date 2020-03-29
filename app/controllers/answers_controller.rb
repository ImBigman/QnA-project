class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  after_action :publish_answer, only: %i[create]

  include Voted

  authorize_resource

  def index
    question.answers
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      AnswersSubscriptionsJob.perform_later(question, @answer) if question.subscriptions.exists?
    end
  end

  def update
    authorize! :update, answer
    answer.update(answer_params)
  end

  def destroy
    authorize! :destroy, answer
    answer.destroy
  end

  def make_better
    answer.up_to_best!
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def publish_answer
    return if answer.errors.any?

    ActionCable.server.broadcast("answers_for_question_#{question.id}",
                                 author: answer.user.email,
                                 rating: answer.rating,
                                 answer: answer,
                                 links: answer.links)
  end

  helper_method :question
  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body, :author_id,
                                   files: [],
                                   links_attributes: %i[id name url _destroy])
  end
end
