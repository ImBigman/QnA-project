require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:questions) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:question) { create(:question, user: user) }

  it 'owns question' do
    expect(user.owner?(question)).to be true
  end

  it 'Other user is not the owner of the question' do
    expect(user1.owner?(question)).to be false
  end
end
