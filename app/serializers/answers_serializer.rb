class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :author, :created_at, :updated_at

  def author
    object.user.email
  end
end
