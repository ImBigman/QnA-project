require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(10) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question, best: true) }
  let(:answer1) { create(:answer, user: user, question: question, best: false) }

  describe '#best?' do
    it 'is the best?' do
      expect(answer).to be_best
    end

    it 'is not the best?' do
      expect(answer1).to_not be_best
    end
  end

  describe '.by_worth scope' do
    it 'includes answer with best: true' do
      expect(Answer.by_worth).to eq [answer]
    end

    it 'excludes answer without best: false' do
      expect(Answer.by_worth).not_to eq [answer1]
    end
  end

  it 'up_to_best make answer the best' do
    answer1.up_to_best
    expect(answer1).to be_best
  end
end
