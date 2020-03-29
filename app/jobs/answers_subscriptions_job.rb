class AnswersSubscriptionsJob < ApplicationJob
  queue_as :default

  def perform(question, answer)
    DailyDigestService.new.send_new_answers(question, answer)
  end
end
