class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  after_action :publish_question, only: %i[create destroy]

  include Voted

  authorize_resource

  def index
    @questions = Question.order(:created_at)
  end

  def show
    @answer = Answer.new
    @answer.links.build
    gon.question_id = question.id
    gon.question_owner_id = question.user_id
  end

  def new
    question.build_reward
    question.links.build
  end

  def edit; end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      current_user.subscriptions.create(question_id: @question.id)
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new, alert: 'Your question has not been saved! '
    end
  end

  def update
    authorize! :update, question
    question.update(question_params)
  end

  def destroy
    authorize! :destroy, question
    redirect_to questions_path, notice: "Your question '#{question.title[0..-2]}' successfully deleted." if question.destroy
  end

  private

  def publish_question
    return if question.errors.any?

    ActionCable.server.broadcast('questions',
                                 action: action_name,
                                 id: question.id,
                                 item: ApplicationController.render(partial: 'questions/question',
                                                                    locals: { question: question }))
  end

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
