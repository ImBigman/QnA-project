class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index]

  def index
    question.answers
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    current_user.owner?(answer) ? answer.destroy : nil
  end

  def make_better
    @question = answer.question
    return unless current_user.owner?(answer.question)

    @question.answers.by_worth.first.nil? ?  answer.up_to_best : @question.answers.by_worth.first.usual && answer.up_to_best
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question
  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body, :author_id)
  end
end
