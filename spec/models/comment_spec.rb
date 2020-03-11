require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:commentable) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(10) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:comment) { build(:comment, commentable: question, user: user) }
  let(:comment1) { build(:comment, commentable: question, user: user) }

  it 'must be in the right order' do
    [comment, comment1].each(&:save)

    expect(Comment.all).to eq([comment, comment1])
  end
end
