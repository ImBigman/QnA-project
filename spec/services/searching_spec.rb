require 'rails_helper'

RSpec.describe SearchingService do
  let(:params) { ActionController::Parameters.new(body: 'question', scope: 'questions').permit! }
  let(:params1) { ActionController::Parameters.new(body: 'question', scope: 'global').permit! }
  let(:service) { SearchingService.new(params) }
  let(:request) { params['body'].split(/'([^']+)'|"([^"]+)"|\s+|\+/).reject(&:empty?).map(&:inspect) }

  it 'search for a specific resource' do
    expect(params['scope'].capitalize.singularize.constantize).to receive(:search).with(ThinkingSphinx::Query.escape(request.to_s)).and_call_original

    service.call
  end

  context 'search without resource' do
    let(:service) { SearchingService.new(params1) }
    let(:request1) { params1['body'].split(/'([^']+)'|"([^"]+)"|\s+|\+/).reject(&:empty?).map(&:inspect) }

    it 'search with global scope' do
      expect(ThinkingSphinx).to receive(:search).with(ThinkingSphinx::Query.escape(request1.to_s)).and_call_original

      service.call
    end
  end
end



