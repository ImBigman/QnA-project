require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe '#gist_javascript_tag' do
    let(:gist_link) { create(:link, name: 'First', url: 'https://gist.github.com/ImBigman/8ca778b06a47e698bdbbb0b149f8dbdf', linkable: question) }

    it 'returns the gist render ready tag' do
      expect(javascript_link_tag(gist_link)).to eq('<script src=' + gist_link.url + '.js></script>')
    end
  end

  describe '#pathfinder' do
    let(:action) { 'positive_vote' }

    it 'returns the vote path for resource' do
      expect(pathfinder(action, question)).to eq("/questions/#{question.id}/#{action}")
    end
  end
end

