require 'rails_helper'

describe 'Questions API', type: :request do
  let(:access_token) { create(:access_token) }
  let(:user) { create(:user) }
  let(:headers) {
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  }
  describe 'GET api/v1/questions' do

    it_behaves_like 'API Authorizable', let(:api_path) { '/api/v1/questions' }, let(:method) { :get }

    context 'authorized' do
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(20)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET api/v1/questions/:id' do

    it_behaves_like 'API Authorizable', let(:api_path) { '/api/v1/questions/:id' }, let(:method) { :get }

    context 'authorized' do
      let(:question) { create(:question, :with_files, :with_links, user: user) }
      let!(:comment) { create(:comment, commentable: question, user: user) }
      let(:question_response) { json['question'] }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it_behaves_like 'API resource contains' do
        let(:resource_response) { question_response }
        let(:instance) { question }
      end
    end
  end

  describe 'POST api/v1/questions/' do
    let(:api_path) { '/api/v1/questions/' }
    let(:method) { :post }

    it_behaves_like 'API Authorizable' do
      let(:headers) { { 'ACCEPT' => 'application/json' } }
    end

    context 'authorized' do
      it_behaves_like 'API create resource' do
        let(:resource) { Question }
        let(:token) { access_token.token }
        let(:attributes) do
          { title: 'Test question title',
            body: 'Test question body',
            user_id: access_token.resource_owner_id }
        end
        let(:attributes_inv) do
          { title: 'Test',
            body: 'Test',
            user_id: access_token.resource_owner_id }
        end
      end
    end
  end

  describe 'PATCH api/v1/questions/:id' do
    let(:api_path) { '/api/v1/questions/:id' }
    let(:method) { :patch }

    it_behaves_like 'API Authorizable' do
      let(:headers) { { 'ACCEPT' => 'application/json' } }
    end

    context 'authorized' do
      let(:question) { create(:question, user_id: access_token.resource_owner_id) }
      let(:api_path) { "/api/v1/questions/#{question.id}" }

      it_behaves_like 'API update resource' do
        let(:instance) { question }
        let(:resource) { Question }
        let(:token) { access_token.token }
        let(:attributes) do
          { title: 'New test question title',
            body: 'New test question body',
            user_id: access_token.resource_owner_id }
        end
        let(:attributes_inv) do
          { title: 'Test',
            body: 'Test',
            user_id: access_token.resource_owner_id }
        end
      end
    end
  end

  describe 'DELETE api/v1/questions/:id' do
    let(:api_path) { '/api/v1/questions/:id' }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable' do
      let(:headers) { { 'ACCEPT' => 'application/json' } }
    end

    context 'authorized' do
      let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
      let(:api_path) { "/api/v1/questions/#{question.id}" }

      it_behaves_like 'API destroy resource' do
        let(:instance) { question }
        let(:resource) { Question }
        let(:token) { access_token.token }
        let(:attributes) { { user_id: access_token.resource_owner_id } }
      end
    end
  end
end
