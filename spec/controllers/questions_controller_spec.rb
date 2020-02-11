require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:questions) { create_list(:question, 3, user: user) }

  describe 'POST #index' do
    before do
      login(user)
      get :index
    end

    it 'populates of array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'POST #show' do
    before do
      login(user)
      get :show, params: { id: question }
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #new' do
    it 'renders new view' do
      login(user)
      get :new

      expect(response).to render_template :new
    end
  end

  describe 'POST #edit' do
    before do
      login(user)
      get :edit, params: { id: question }
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'As user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post :create, params: { question: attributes_for(:question, user: user) } }.to change(Question, :count).by(1)
        end

        it 'becomes an author of the question' do
          post :create, params: { question: attributes_for(:question, user: user) }
          expect(assigns(:question).user).to eq user
        end

        it 'redirect to show view' do
          post :create, params: { question: attributes_for(:question, user: user) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 're-render new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context 'As guest' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, user: user) } }.to_not change(Question, :count)
      end

      it 'redirected to sing in page' do
        post :create, params: { question: attributes_for(:question, user: user) }

        expect(response.status).to eq 302
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question, user: user) }
        expect(assigns(:question)).to eq question
      end

      it 'change questions attributes' do
        patch :update, params: { id: question, question: { title: 'new title for', body: 'new body for', user: user } }
        question.reload

        expect(question.title).to eq 'new title for'
        expect(question.body).to eq 'new body for'
      end

      it 'redirect to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question, user: user) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }
      it 'does not change question' do
        question.reload

        expect(question.title).to eq question.title
        expect(question.body).to eq 'Its test question body'
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'As an author' do
      before { login(user) }

      let!(:question) { create(:question, user: user) }

      it 'delete a question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end
      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'As not an author' do
      before { login(user1) }

      let!(:question) { create(:question, user: user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'get flash alert message' do
        delete :destroy, params: { id: question }
        expect(flash[:alert]).to eq "You can't delete not your question!"
      end
    end

    context 'As guest' do
      let!(:question) { create(:question, user: user) }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'redirected to sing in page' do
        delete :destroy, params: { id: question }

        expect(response.status).to eq 302
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end


