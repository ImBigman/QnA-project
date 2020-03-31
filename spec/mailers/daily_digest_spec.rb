require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  let(:user) { create(:user) }
  let!(:questions) { create_list(:question, 2, user: user, created_at: Time.now) }
  let!(:answer) { create(:answer, user: user, question: questions.first) }

  describe "digest" do
    let(:mail) { DailyDigestMailer.digest(user) }
    let(:questions_titles) { questions.map(&:title).join(', ') }

    it "renders the headers" do
      expect(mail.subject).to eq("New Questions: #{questions_titles}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("New Questions:")
    end
  end

  describe "answers" do
    let(:mail) { DailyDigestMailer.answers(user, answer) }
    let(:question) { questions.first.title.to_s }
    let(:answer_body) { answer.body.truncate(20) }

    it "renders the headers" do
      expect(mail.subject).to eq("New #{question} answers")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("New answer of #{question}: #{answer_body}")
    end
  end
end

