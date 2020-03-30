class DailyDigestService
  def send_digest
    User.find_each do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end

  def send_new_answers(question, answer)
    question.subscriptions.find_each do |subscription|
      DailyDigestMailer.answers(subscription.user, answer).deliver_later
    end
  end
end
