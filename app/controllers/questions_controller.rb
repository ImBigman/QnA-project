class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.order(:created_at)
  end

  def show
    @answer = Answer.new
    @answer.links.build
  end

  def new
    question.build_reward
    question.links.build
  end

  def edit; end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new, alert: 'Your question has not been saved! '
    end
  end

  def update
    question.update(question_params) if current_user.owner?(question)
  end

  def destroy
    if current_user.owner?(question)
      question.destroy
      redirect_to questions_path, notice: "Your question '#{question.title[0..-2]}' successfully deleted."
    else
      redirect_to @question, alert: "You can't delete not your question!"
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, :author_id,
                                     files: [],
                                     links_attributes: %i[id name url _destroy],
                                     reward_attributes: %i[id name image _destroy])
  end
end
