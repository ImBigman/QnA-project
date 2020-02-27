require 'rails_helper'
require Rails.root.join 'spec/concerns/links_concern_spec.rb'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_least(10) }
  it { should validate_length_of(:body).is_at_least(10) }

  it_behaves_like 'links_concern'

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
