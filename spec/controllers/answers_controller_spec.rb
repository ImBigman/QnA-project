require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }

  describe 'POST #new' do
    it 'renders new view' do
      login(user)
      get :new, params: { question_id: question }

      expect(response).to render_template :new
    end
  end

  describe 'POST #edit' do
    before do
      login(user)
      get :edit, params: { id: answer }
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'As user' do

      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { question_id: question, user: user, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
        end

        it 'becomes an author of the answer' do
          post :create, params: { question_id: question, user: user, answer: attributes_for(:answer) }
          expect(answer.user).to eq user
        end

        it 'redirect to show view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: question, user: user, answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
        end

        it 're-render new view' do
          post :create, params: { question_id: question, user: user, answer: attributes_for(:answer, :invalid) }
          expect(response).to redirect_to question_path(question)
        end
      end
    end

    context 'As guest' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to_not change(question.answers, :count)
      end

      it 'redirected to sing in page' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        expect(response.status).to eq 302
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'change answers attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body for answer' } }
        answer.reload

        expect(answer.body).to eq 'new body for answer'
      end

      it 'redirect to updated answer' do
        patch :update, params: { id: answer, answer: { body: 'new body for answer' } }
        answer.reload

        expect(response).to redirect_to answer.question
        expect(flash[:notice]).to eq 'Your answer successful updated!'
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }
      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq 'This is test answer for some question'
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'As an author' do
      before { login(user) }

      let!(:answer) { create(:answer, question: question, user: user) }

      it 'delete a answer' do
        expect { delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end

    context 'As not an author' do
      before { login(user1) }

      let!(:answer) { create(:answer, question: question, user: user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer } }.not_to change(question.answers, :count)
      end

      it 'get flash alert message' do
        delete :destroy, params: { id: answer }
        expect(flash[:alert]).to eq "You can't delete not your answer!"
      end
    end

    context 'As guest' do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer } }.not_to change(question.answers, :count)
      end

      it 'redirected to sing in page' do
        delete :destroy, params: { id: answer }

        expect(response.status).to eq 302
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
