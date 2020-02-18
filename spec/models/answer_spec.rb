require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(10) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question, best: true) }
  let!(:answer1) { create(:answer, user: user, question: question) }
  let!(:answer2) { create(:answer, user: user, question: question) }

  describe '#best?' do
    it 'is the best?' do
      expect(answer).to be_best
    end

    it 'is not the best?' do
      expect(answer1).to_not be_best
    end
  end

  describe 'up_to_best!' do
    before { answer1.up_to_best! }

    it 'make answer the best' do
      expect(answer1).to be_best
    end

    it 'makes the old best answer ordinary' do
      answer.reload

      expect(answer).not_to be_best
    end

    it 'should make the right order' do
      [answer, answer2].each(&:reload)

      expect(Answer.default_scoped.to_sql).to eq Answer.all.order(best: :desc).order(:created_at).to_sql
      expect(Answer.all).to eq([answer1, answer, answer2])
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
