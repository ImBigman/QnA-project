require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:question) { create :question, user: user }

  describe 'POST #create' do
    context 'As user' do

      before { login(user) }

      it 'saves a new subscription in the database' do
        expect do
          post :create, params: { question_id: question, user: user, subscription: attributes_for(:subscription), format: :js }
        end.to change(question.subscriptions, :count).by(1)
      end

      it 'render create view' do
        post :create, params: { question_id: question, user: user, subscription: attributes_for(:subscription), format: :js }

        expect(response).to render_template :create
      end
    end

    context 'As guest' do
      it 'does not save the answer' do
        expect do
          post :create, params: { question_id: question, subscription: attributes_for(:subscription), format: :js }
        end.to_not change(question.subscriptions, :count)
      end

      it 'redirected to sign in page' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        expect(response.status).to eq 302
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'As an author' do
      before { login(user) }

      let!(:subscription) { create(:subscription, question: question, user: user) }

      it 'delete the subscription' do
        expect { delete :destroy, params: { id: subscription, format: :js } }.to change(question.subscriptions, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: subscription, format: :js }

        expect(response).to render_template :destroy
      end
    end

    context 'As not an author' do
      before { login(user1) }

      let!(:subscription) { create(:subscription, question: question, user: user) }

      it 'does not delete the subscription' do
        expect { delete :destroy, params: { id: subscription, format: :js } }.not_to change(question.subscriptions, :count)
      end

      it 'redirect to root path' do
        delete :destroy, params: { id: subscription, format: :js }

        expect(response).to redirect_to root_path
      end
    end

    context 'As guest' do
      let!(:subscription) { create(:subscription, question: question, user: user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: subscription, format: :js } }.not_to change(question.subscriptions, :count)
      end

      it 'render flash alert' do
        delete :destroy, params: { id: subscription, format: :js }

        expect(response.status).to eq 401
        expect(response.body).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end
end
