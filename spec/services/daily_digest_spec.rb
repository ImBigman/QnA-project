require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question, user: users.first) }
  let(:answer) { create(:answer, question: question, user: users.first) }

  it 'sends daily digest to all users' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original }
    subject.send_digest
  end

  it 'sends email to all question subscribers' do
    subscribers = question.subscriptions.map(&:user_id)
    users.each { |user| expect(DailyDigestMailer).to receive(:answers).with(user, answer).and_call_original if subscribers.include?(user.id)}
    subject.send_new_answers(question, answer)
  end
end
