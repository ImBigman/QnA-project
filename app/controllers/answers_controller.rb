class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def show; end

  def new; end

  def edit; end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @answer.question, notice: 'Your answer has been successfully added.'
    else
      render 'questions/show'
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to @answer.question, notice: 'Your answer successful updated!'
    else
      render :edit, alert: 'Your answer has not been saved!'
    end
  end

  def destroy
    if current_user.owner?(answer)
      answer.destroy
      redirect_to answer.question, notice: 'Your answer successfully deleted.'
    else
      redirect_to answer.question, alert: "You can't delete not your answer!"
    end
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
