require 'rails_helper'

feature 'User can sign in with vkontakte authorization', %q(
  "In order to ask questions as an unauthenticated user
   I'd like to able to sign in"
) do
  background do
    visit questions_path
    click_on 'Sign in'
  end

  describe 'Registered user' do
    given!(:user) { create(:user, email: 'test@mail.ru') }
    given!(:authorization) { create(:authorization, user: user, provider: 'vkontakte', uid: '123456') }

    scenario 'try to sign in' do
      mock_auth_hash('vkontakte', email: '')

      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from vkontakte account.'
    end

    scenario 'try to sign in with failure' do
      clean_mock_auth('vkontakte')
      failure_mock_auth('vkontakte')

      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Could not authenticate you from Vkontakte because "Invalid credentials".'
    end
  end

  describe 'Unregistered user' do
    background do
      clean_mock_auth('vkontakte')
      mock_auth_hash('vkontakte', email: '')
      click_on 'Sign in with Vkontakte'
    end

    scenario 'sign in with email confirmation form' do
      expect(page).to have_content 'Email confirmation'

      fill_in 'user[email]', with: 'test_mail@test.com'
      click_on 'Send'

      expect(page).to have_content 'Please confirm your email'
    end

    scenario 'try to sign in without confirmation' do
      fill_in 'user[email]', with: 'test_mail@test.com'
      click_on 'Send'

      visit 'users/sign_in'
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'You have to confirm your email address before continuing.'
    end

    scenario 'try to sign in with empty email' do
      fill_in 'user[email]', with: ''
      click_on 'Send'

      expect(page).to have_content 'Email can not be blank!'
    end

    scenario 'try to sign in with confirmation' do
      fill_in 'user[email]', with: 'test_mail@test.com'
      click_on 'Send'

      open_email('test_mail@test.com')
      current_email.click_link 'Confirm my account'

      click_on 'Sign in with Vkontakte'
      expect(page).to have_content 'Successfully authenticated from vkontakte account'
    end

    describe 'try to sign in with' do
      given!(:user) { create(:user, email: 'test@mail.ru') }
      given!(:authorization) { create(:authorization, user: user, provider: 'github', uid: '1234567') }

      scenario 'existing email' do
        fill_in 'user[email]', with: 'test@mail.ru'
        click_on 'Send'

        expect(page).to have_content 'Welcome back, test@mail.ru!'
        open_email('test@mail.ru')
        current_email.click_link 'Confirm my account'

        click_on 'Sign in with Vkontakte'
        expect(page).to have_content 'Successfully authenticated from vkontakte account'
      end
    end
  end

  scenario 'Unregistered try to sign in with failure' do
    clean_mock_auth('vkontakte')
    failure_mock_auth('vkontakte')

    click_on 'Sign in with Vkontakte'

    expect(page).to have_content 'Could not authenticate you from Vkontakte because "Invalid credentials".'
  end
end

