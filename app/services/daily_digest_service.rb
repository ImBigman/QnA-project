class DailyDigestService
  def send_digest
    User.find_each do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end

  def send_new_answers(question, answer)
    @subscribers = question.subscriptions.map(&:user_id)
    User.find_each do |user|
      DailyDigestMailer.answers(user, answer).deliver_later if @subscribers.include?(user.id)
    end
  end
end
