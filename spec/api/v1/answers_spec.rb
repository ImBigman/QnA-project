require 'rails_helper'

describe 'Answers API', type: :request do
  let(:access_token) { create(:access_token) }
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:headers) {
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  }

  describe 'GET api/v1/questions/:id/answers' do

    it_behaves_like 'API Authorizable', let(:api_path) { "/api/v1/questions/#{question.id}/answers" }, let(:method) { :get }

    context 'authorized' do
      let(:answer_response) { json['answers'].first }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answers.first.send(attr).as_json
        end
      end
    end
  end

  describe 'GET api/v1/answers/:id' do

    it_behaves_like 'API Authorizable', let(:api_path) { '/api/v1/answers/:id' }, let(:method) { :get }

    context 'authorized' do
      let(:answer) { create(:answer, :with_links, :with_files, question: question, user: user) }
      let!(:comment) { create(:comment, commentable: answer, user: user) }
      let(:answer_response) { json['answer'] }

      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'API resource contains' do
        let(:resource_response) { answer_response }
        let(:instance) { answer }
      end
    end
  end

  describe 'POST api/v1/questions/:id/answers/' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/" }
    let(:method) { :post }

    it_behaves_like 'API Authorizable' do
      let(:headers) { { 'ACCEPT' => 'application/json' } }
    end

    context 'authorized' do
      it_behaves_like 'API create resource' do
        let(:resource) { Answer }
        let(:token) { access_token.token }
        let(:attributes) do
          { question: question,
            body: 'Test answer body',
            user_id: access_token.resource_owner_id }
        end
        let(:attributes_inv) do
          { question: question,
            body: 'Test',
            user_id: access_token.resource_owner_id }
        end
      end
    end
  end

  describe 'PATCH api/v1/answers/:id' do
    let(:answer) { create(:answer, question: question, user_id: access_token.resource_owner_id) }
    let(:api_path) { '/api/v1/answers/:id' }
    let(:method) { :patch }

    it_behaves_like 'API Authorizable' do
      let(:headers) { { 'ACCEPT' => 'application/json' } }
    end

    context 'authorized' do
      it_behaves_like 'API update resource' do
        let(:api_path) { "/api/v1/answers/#{answer.id}" }
        let(:instance) { answer }
        let(:resource) { Answer }
        let(:token) { access_token.token }
        let(:attributes) do
          { question: question,
            body: 'New test question body',
            user_id: access_token.resource_owner_id }
        end
        let(:attributes_inv) do
          { question: question,
            body: 'Test',
            user_id: access_token.resource_owner_id }
        end
      end
    end
  end

  describe 'DELETE api/v1/answers/:id' do
    let(:api_path) { '/api/v1/answers/:id' }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable' do
      let(:headers) { { 'ACCEPT' => 'application/json' } }
    end

    context 'authorized' do
      let!(:answer) { create(:answer, question: question, user_id: access_token.resource_owner_id) }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }

      it_behaves_like 'API destroy resource' do
        let(:instance) { answer }
        let(:resource) { Answer }
        let(:token) { access_token.token }
        let(:attributes) { { user_id: access_token.resource_owner_id } }
      end
    end
  end
end
