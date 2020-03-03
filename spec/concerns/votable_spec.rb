require 'spec_helper'

shared_examples_for 'votable' do |klass|

  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:model) { described_class }
  let(:question) { create(:question, user: user) }

  if klass == 'Question'
    let(:votable) { create(model.to_s.underscore.to_sym, user: user) }
  else
    let(:votable) { create(model.to_s.underscore.to_sym, question: question, user: user) }
  end

  let!(:votes) { create_list(:vote, 3, votable: votable, score: 1, user_id: user.id) }

  describe '#recount ' do
    it 'returns summary vote scores for resource' do
      expect(votable.recount).to eq(3)
    end
  end
end

