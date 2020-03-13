require 'rails_helper'

RSpec.describe CommentsChannel, type: :channel do
  let(:user) { create(:user) }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user, best: false }

  before { stub_connection user_id: user.id }

  it 'subscribes' do
    subscribe

    expect(subscription).to be_confirmed
  end


  it 'subscribes to a stream when question is provided' do
    subscribe(question_id: question.id)

    expect(subscription).to be_confirmed

    # check particular stream by name
    expect(subscription).to have_stream_from("question_#{question.id}_comments")

    # or directly by model if you create streams with `stream_for`
    expect(subscription).to have_stream_for("question_#{question.id}_comments")
  end
end
