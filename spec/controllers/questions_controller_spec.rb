require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author_id: user.id) }

  describe 'POST #index' do
    before do
      question1 = create(:question, author_id: user.id)
      question2 = create(:question, author_id: user.id)
      question3 = create(:question, author_id: user.id)
      @questions = [question1, question2, question3]
      login(user)
      get :index
    end

    it 'populates of array of all questions' do
      expect(assigns(:questions)).to match_array(@questions)
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
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question, author_id: user.id) } }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question, author_id: user.id) }
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

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question, author_id: user.id) }
        expect(assigns(:question)).to eq question
      end

      it 'change questions attributes' do
        patch :update, params: { id: question, question: { title: 'new title for', body: 'new body for', author_id: user.id } }
        question.reload

        expect(question.title).to eq 'new title for'
        expect(question.body).to eq 'new body for'
      end

      it 'redirect to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question, author_id: user.id) }
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
    before { login(user) }

    let!(:question) { create(:question, author_id: user.id) }

    it 'delete a question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end
    it 'redirect to index view' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end


