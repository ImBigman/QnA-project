require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user, best: false }

  describe 'POST #create' do
    context 'As user' do

      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { question_id: question, user: user, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
        end

        it 'becomes an author of the answer' do
          post :create, params: { question_id: question, user: user, answer: attributes_for(:answer), format: :js }
          expect(assigns(:answer).user).to eq user
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: question, user: user, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(question.answers, :count)
        end

        it 're-render new view' do
          post :create, params: { question_id: question, user: user, answer: attributes_for(:answer, :invalid), format: :js }
          expect(response).to render_template :create
        end
      end
    end

    context 'As guest' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to_not change(question.answers, :count)
      end

      it 'redirected to sign in page' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        expect(response.status).to eq 302
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'PATCH #update' do
    context 'As an author' do
      before { login(user) }

      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
          expect(assigns(:answer)).to eq answer
        end

        it 'change answers attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body for answer' } }, format: :js
          answer.reload

          expect(answer.body).to eq 'new body for answer'
        end

        it 'render update view' do
          patch :update, params: { id: answer, answer: { body: 'new body for answer' } }, format: :js

          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer' do
          patch(:update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js)
          answer.reload

          expect(answer.body).to eq answer.body
        end

        it 're-render edit view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'As not an author' do
      before { login(user1) }

      it 'does not change answer' do
        patch(:update, params: { id: answer, user: user, answer: { body: 'new body for answer' } }, format: :js)
        answer.reload

        expect(answer.body).to_not eq 'new body for answer'
      end

      it 're-render edit view' do
        patch(:update, params: { id: answer, user: user, answer: attributes_for(:answer) }, format: :js)
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'As an author' do
      before { login(user) }

      let!(:answer) { create(:answer, question: question, user: user) }

      it 'delete a answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(question.answers, :count).by(-1)
      end
    end

    context 'As not an author' do
      before { login(user1) }

      let!(:answer) { create(:answer, question: question, user: user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.not_to change(question.answers, :count)
      end
    end

    context 'As guest' do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer } }.not_to change(question.answers, :count)
      end

      it 'redirected to sign in page' do
        delete :destroy, params: { id: answer }

        expect(response.status).to eq 302
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'PATCH #make_better' do
    context 'As an author of question' do
      before { login(user) }

      it 'make the answer the best' do
        patch :make_better, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        answer.reload

        expect(answer).to be_best
      end

      it 'render make_better view' do
        patch :make_better, params: { id: answer, answer: attributes_for(:answer) }, format: :js

        expect(response).to render_template :make_better
      end
    end

    context 'As not an author' do
      before { login(user1) }

      it 'does not change answer' do
        patch :make_better, params: { id: answer, user: user, answer: attributes_for(:answer) }, format: :js
        answer.reload

        expect { answer.best }.to_not change(answer, :best)
      end

      it 'render make_better view' do
        patch :make_better, params: { id: answer, answer: attributes_for(:answer) }, format: :js

        expect(response).to render_template :make_better
      end
    end
  end
end
