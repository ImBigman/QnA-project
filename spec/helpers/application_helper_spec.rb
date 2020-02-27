require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#gist_javascript_tag' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:link) { create(:link, name: 'First', url: 'https://gist.github.com/ImBigman/8ca778b06a47e698bdbbb0b149f8dbdf', linkable: question) }

    it 'returns the gist render ready tag' do
      expect(gist_tag_helper(link)).to eq('<script src=' + link.url + '.js></script>')
    end
  end
end

