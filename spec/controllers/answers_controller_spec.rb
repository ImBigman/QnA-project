require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:answer) { create :answer }

  describe 'POST #create' do
    let(:answer) { create :answer }
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: { question_id: question.id, body: "This is test answer for some question" } } }.to change(question.answers, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question_id: question.id, answer: { question_id: question.id, body: "This is test answer for some question" } }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
      end

      it 're-render new view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create :answer,  question_id: question.id }
    context 'with valid attributes' do
      it 'change answers attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body for answer' } }
        answer.reload

        expect(answer.body).to eq 'new body for answer'
      end

      it 'redirect to updated answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer.question
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
    let!(:answer) { create(:answer, question_id: question.id) }

    it 'delete a answer' do
      expect { delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to answer.question
    end
  end
end
