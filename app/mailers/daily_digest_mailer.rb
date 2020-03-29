class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where('created_at > ?', 1.days.ago).map(&:title).join(', ')
    @greeting = "Hello, #{user.email}"

    mail to: user.email, subject: "New Questions: #{@questions}"
  end

  def answers(user, answer)
    @question = answer.question.title.to_s
    @answer = answer.body.truncate(20)

    @greeting = "Hello, #{user.email}"

    mail to: user.email, subject: "New #{@question} answers"
  end
end
