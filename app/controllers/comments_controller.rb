class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: %i[create]

  authorize_resource

  def create
    @comment = commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast("question_#{question_id}_comments",
                                 id: commentable.id,
                                 type: commentable.class.name.underscore,
                                 author: @comment.user.email,
                                 comment: @comment)
  end

  def question_id
    if commentable.class == Question
      commentable.id
    else
      commentable.question.id
    end
  end

  def commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
