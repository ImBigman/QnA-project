require 'spec_helper'

shared_examples_for 'votable' do

  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:model) { described_class }
  let(:question) { create(:question, user: user) }
  let!(:votes) { create_list(:vote, 2, votable: votable, score: 1, user: user) }

  describe '#rating' do
    it 'returns summary vote scores for resource' do
      expect(votable.rating).to eq(2)
    end
  end
end
