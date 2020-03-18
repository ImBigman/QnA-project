require 'rails_helper'

feature 'User can sign in with GitHub authorization', %q(
  "In order to ask questions as an unauthenticated user
   I'd like to able to sign in"
) do
  given!(:user) { create(:user, email: 'test@mail.ru') }

  background do
    visit questions_path
    click_on 'Sign in'
  end

  describe 'Registered user' do
    scenario 'try to sign in' do
      mock_auth_hash('github', email: 'test@mail.ru')

      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from GitHub account.'
    end

    scenario 'try to sign in with failure' do
      clean_mock_auth('github')
      failure_mock_auth('github')

      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials".'
    end
  end

  describe 'Unregistered user' do
    background do
      clean_mock_auth('github')
      mock_auth_hash('github', email: 'test1@mail.ru')
    end

    scenario 'try to sign in' do
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'You have to confirm your email address before continuing'
    end

    scenario 'try to sign in with confirmation' do
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'You have to confirm your email address before continuing'

      open_email('test1@mail.ru')
      current_email.click_link 'Confirm my account'

      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Successfully authenticated from GitHub account'
    end

    scenario 'try to sign in with failure' do
      clean_mock_auth('github')
      failure_mock_auth('github')

      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials".'
    end
  end
end

