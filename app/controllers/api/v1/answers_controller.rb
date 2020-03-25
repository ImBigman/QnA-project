module Api
  module V1
    class AnswersController < BaseController
      before_action :set_question, only: %i[index create]
      before_action :set_answer, only: %i[show update destroy]

      authorize_resource

      def index
        render json: @answers, each_serializer: AnswersSerializer
      end

      def show
        render json: @answer
      end

      def new; end

      def create
        @answer = @question.answers.new(answer_params)
        @answer.user = current_resource_owner
        if @question.save
          head 200
        else
          head 422
        end
      end

      def update
        if @answer.update(answer_params)
          head 200
        else
          head 422
        end
      end

      def destroy
        @answer.destroy
      end

      private

      def set_question
        @question = Question.find(params[:question_id])
        @answers = @question.answers
      end

      def set_answer
        @answer = Answer.find(params[:id])
      end

      def answer_params
        params.require(:answer).permit(:body, :author_id)
      end
    end
  end
end
