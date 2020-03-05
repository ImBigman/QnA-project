class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index]

  include Voted

  def index
    question.answers
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    answer.update(answer_params) if current_user.owner?(answer)
  end

  def destroy
    answer.destroy if current_user.owner?(answer)
  end

  def make_better
    answer.up_to_best! if current_user.owner?(answer.question)
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
    params.require(:answer).permit(:body, :author_id,
                                   files: [],
                                   links_attributes: %i[id name url _destroy])
  end
end
