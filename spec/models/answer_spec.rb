require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(10) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question, best: true) }
  let!(:answer1) { create(:answer, user: user, question: question,  best: false) }
  let!(:answer2) { create(:answer, user: user, question: question,  best: false) }
  let!(:reward) { create :reward, question: question }

  it_behaves_like 'linkable'
  it_behaves_like 'attachable'
  it_behaves_like 'votable', 'Answer'

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

    it 'reward the best answer author' do
      answer1.reload
      reward.reload

      expect(answer1).to be_best
      expect(reward.user).to eq user
    end

    it 'should make the right order' do
      [answer, answer2].each(&:reload)

      expect(Answer.default_scoped.to_sql).to eq Answer.all.order(best: :desc).order(:created_at).to_sql
      expect(Answer.all).to eq([answer1, answer, answer2])
    end
  end
end
