class DailyDigestService
  def send_digest
    User.find_each do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end

  def send_new_answers(question, answer)
    question.subscribers.find_each do |subscriber|
      DailyDigestMailer.answers(subscriber, answer).deliver_later
    end
  end
end
