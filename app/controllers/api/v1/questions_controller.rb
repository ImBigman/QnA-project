module Api
  module V1
    class QuestionsController < BaseController
      before_action :set_question, except: [:create]

      authorize_resource

      def index
        @questions = Question.all
        render json: @questions, each_serializer: QuestionsSerializer
      end

      def show
        render json: @question
      end

      def new; end

      def create
        @question = current_resource_owner.questions.build(question_params)
        if @question.save
          head 200
        else
          head 422
        end
      end

      def update
        if @question.update(question_params)
          head 200
        else
          head 422
        end
      end

      def destroy

        @question.destroy
      end

      private

      def set_question
        @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
      end

      def question_params
        params.require(:question).permit(:title, :body, :author_id)
      end
    end
  end
end
