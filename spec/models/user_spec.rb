require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:question) { create(:question, user: user) }

  it 'owns question' do
    expect(user).to be_owner(question)
  end

  it 'Other user is not the owner of the question' do
    expect(user1).not_to be_owner(question)
  end
end
