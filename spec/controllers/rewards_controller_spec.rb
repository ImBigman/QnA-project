require 'rails_helper'

RSpec.describe RewardsController, type: :controller do

  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:question1) { create(:question, user: user1) }
  let(:answer) { create :answer, question: question, user: user, best: true }
  let(:answer) { create :answer, question: question1, user: user, best: true }
  let!(:reward) { create :reward, question: question, user: user }
  let!(:reward1) { create :reward, question: question1, user: user }
  let(:rewards) { [reward, reward1] }

  describe 'GET #index' do
    describe 'As user' do
      before do
        login(user)
        get :index
      end

      it 'populates of array of all current user awards' do
        expect(assigns(:rewards)).to match_array(rewards)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    describe 'As guest' do
      before { get :index }

      it 'try to access to awards list' do
        expect(response.status).to eq 302
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
