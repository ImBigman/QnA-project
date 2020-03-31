require 'rails_helper'

RSpec.describe AnswersSubscriptionsJob, type: :job do
  let(:service) { double('DailyDigestService') }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  before do
    allow(DailyDigestService).to receive(:new).and_return(service)
  end

  it 'calls DailyDigestService#send_new_answers(question, answer)' do
    expect(service).to receive(:send_new_answers).with(question, answer)
    AnswersSubscriptionsJob.perform_now(question, answer)
  end
end
