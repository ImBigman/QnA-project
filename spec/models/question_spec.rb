require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:users).through(:subscriptions).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_least(10) }
  it { should validate_length_of(:body).is_at_least(10) }

  it_behaves_like 'linkable'
  it_behaves_like 'attachable'
  it_behaves_like 'votable', let(:votable) { create(model.to_s.underscore.to_sym, user: user) }

  describe 'question subscriptions' do
    let(:user) { create(:user) }
    let(:user1) { create(:user) }
    let(:question) { create(:question, user: user) }

    it '#subscribed?(user) returns true' do
      expect(question).to be_subscribed(user)
    end

    it '#subscribed?(user) returns false' do
      expect(question).to_not be_subscribed(user1)
    end

    it '#subscription(user)' do
      expect(question.subscription(user)).to eq question.subscriptions.first
    end
  end
end
