require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('https://google.com').for(:url) }
  it { should_not allow_value('foo').for(:url) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:link) { create(:link, name: 'First', url: 'https://gist.github.com/ImBigman/8ca778b06a47e698bdbbb0b149f8dbdf', linkable: question) }
  let(:link1) { create(:link, name: 'Second', url: 'https://google.ru', linkable: question) }

  it 'is gist?' do
    expect(link).to be_gist
  end

  it 'prepared for gist render' do
    expect(link.render_gist).to eq('<script src=' + link.url + '.js></script>')
  end

  it 'must be in the right order' do
    [link, link1].each(&:reload)

    expect(Link.all).to eq([link, link1])
  end
end
