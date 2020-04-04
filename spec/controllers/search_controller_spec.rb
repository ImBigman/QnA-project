require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  let(:user) { create(:user) }
  let!(:questions) { create_list(:question, 2, user: user) }
  let!(:params) { ActionController::Parameters.new(body: 'question', scope: 'questions').permit! }
  let!(:search) { SearchingService.new(params) }

  describe 'GET #index' do
    it 'populates an array of resource as json', sphinx: true do
      ThinkingSphinx::Test.run do
      allow(search).to receive(:call)

      post :searching, params: { search: { body: 'question', scope: 'questions' } }
      expect(JSON.parse(response.body)['response']).to eq questions.as_json
      end
    end

    it 'returns success' do
      expect(response).to have_http_status(:success)
    end

    describe 'search with empty request' do
      let!(:params) { ActionController::Parameters.new(body: '', scope: 'questions').permit! }
      let!(:search) { SearchingService.new(params) }

      it 'returns empty response', sphinx: true do
        ThinkingSphinx::Test.run do
          allow(search).to receive(:call)

          post :searching, params: { search: { body: '', scope: 'questions' } }
          expect(JSON.parse(response.body)['response']).to be_empty
        end
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
