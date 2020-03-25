require 'rails_helper'

describe 'Ability' do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Link }
    it { should be_able_to :read, Reward }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:user1) { create(:user) }
    let(:question) { create(:question, :with_files, user: user) }
    let(:question1) { create(:question, :with_files, user: user1) }
    let(:answer) { create(:answer, :with_files, question: question, user: user) }
    let(:answer1) { create(:answer, :with_files, question: question1, user: user1) }
    let(:comment) { create(:comment, commentable: question, user: user) }
    let(:comment1) { create(:comment, commentable: question, user: user1) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }


    describe 'answer' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, answer1 }

      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, answer1 }

      it { should be_able_to :destroy, answer.files.first }
      it { should_not be_able_to :destroy, answer1.files.first }

      it { should be_able_to :destroy, build(:link, linkable: answer) }
      it { should_not be_able_to :destroy, build(:link, linkable: answer1) }

      it { should be_able_to :make_better, answer }
      it { should_not be_able_to :make_better, answer1 }

      it { should be_able_to %i[positive_vote negative_vote], answer1 }
      it { should_not be_able_to %i[positive_vote negative_vote], answer }
    end

    describe 'question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Reward }

      it { should be_able_to :update, question }
      it { should_not be_able_to :update, question1 }

      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, question1 }

      it { should be_able_to :destroy, question.files.first }
      it { should_not be_able_to :destroy, question1.files.first }

      it { should be_able_to :destroy, build(:link, linkable: question) }
      it { should_not be_able_to :destroy, build(:link, linkable: question1) }

      it { should be_able_to %i[positive_vote negative_vote], question1 }
      it { should_not be_able_to %i[positive_vote negative_vote], question }
    end

    describe 'comment' do
      it { should be_able_to :create, Comment }

      it { should be_able_to :update, comment }
      it { should_not be_able_to :update, comment1 }

      it { should be_able_to :destroy, comment }
      it { should_not be_able_to :destroy, comment1 }
    end

    context 'me' do
      it { should be_able_to :me, user, user: user }
      it { should_not be_able_to :me, user1, user: user }
    end

    context 'other_users' do
      it { should be_able_to :other_users, user, user: user }
      it { should_not be_able_to :other_users, user1, user: user }
    end
  end
end
