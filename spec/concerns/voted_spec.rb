require 'rails_helper'

shared_examples 'voted' do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:controller) { described_class }
  let(:model) { controller.controller_name.classify.constantize }
  let(:question) { create(:question, user: user) }

  describe 'PATCH #positive_vote', format: :json do
    context 'As not an author of resource' do
      before { login(user1) }

      it 'assigns the requested votable to @votable' do
        patch :positive_vote, params: { id: votable, format: :json }
        expect(assigns(:votable)).to eq votable
      end

      it 'vote for resource' do
        patch :positive_vote, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq(1)
      end

      it 'render JSON response' do
        patch :positive_vote, params: { id: votable, format: :json }
        votable.reload

        expect(JSON.parse(response.body)['rating']).to eq(votable.rating)
      end

      it 'can not vote for resource twice' do
        patch :positive_vote, params: { id: votable, format: :json }
        patch :positive_vote, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq(1)
      end

      describe 'You completely change your opinion' do
        let!(:vote) {  create :vote, user_id: user1.id, votable: votable, score: -1 }

        scenario 'from negative to positive' do
          patch :positive_vote, params: { id: votable, format: :json }
          patch :positive_vote, params: { id: votable, format: :json }
          votable.reload

          expect(response.body).to_not eq('You have already voted')
          expect(votable.rating).to eq(1)
        end
      end
    end

    context 'As an author of resource' do
      before { login(user) }

      it 'can not vote for resource' do
        patch :positive_vote, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq(0)
      end

      it 'render JSON response' do
        patch :positive_vote, params: { id: votable, format: :json }
        votable.reload

        expect(response.status).to eq(422)
        expect(response.body).to have_content('You cannot vote for yourself')
      end
    end

    context 'As guest' do
      it 'can not vote for resource' do
        patch :positive_vote, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq(0)
      end

      it 'render JSON response' do
        patch :positive_vote, params: { id: votable, format: :json }
        votable.reload

        expect(response.status).to eq(401)
      end
    end
  end

  describe 'PATCH #negative_vote', format: :json do
    context 'As not an author of resource' do
      before { login(user1) }

      it 'assigns the requested votable to @votable' do
        patch :negative_vote, params: { id: votable, format: :json }
        expect(assigns(:votable)).to eq votable
      end

      it 'vote against of resource' do
        patch :negative_vote, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq(-1)
      end

      it 'render JSON response' do
        patch :negative_vote, params: { id: votable, format: :json }
        votable.reload

        expect(JSON.parse(response.body)['rating']).to eq(votable.rating)
      end

      it 'can not vote against of resource twice' do
        patch :negative_vote, params: { id: votable, format: :json }
        patch :negative_vote, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq(-1)
      end

      describe 'You completely change your opinion' do
        let!(:vote) {  create :vote, user_id: user1.id, votable: votable, score: 1 }

        scenario 'from positive to negative ' do
          patch :negative_vote, params: { id: votable, format: :json }
          patch :negative_vote, params: { id: votable, format: :json }
          votable.reload

          expect(response.body).to_not eq('You have already voted')
          expect(votable.rating).to eq(-1)
        end
      end
    end

    context 'As an author of resource' do
      before { login(user) }

      it 'can not vote against of resource' do
        patch :negative_vote, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq(0)
      end

      it 'render JSON response' do
        patch :negative_vote, params: { id: votable, format: :json }
        votable.reload

        expect(response.status).to eq(422)
        expect(response.body).to have_content('You cannot vote for yourself')
      end
    end

    context 'As guest' do
      it 'can not vote against of resource' do
        patch :negative_vote, params: { id: votable, format: :json }

        expect(votable.rating).to eq(0)
      end

      it 'render JSON response' do
        patch :negative_vote, params: { id: votable, format: :json }
        votable.reload

        expect(response.status).to eq(401)
      end
    end
  end
end
