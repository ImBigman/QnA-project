require 'rails_helper'

feature 'User can sign up', %q(
  "In order to ask questions or add answers
   As an unauthenticated user
   I'd like to able to sign up"
) do

  given(:user) { create(:user) }

  background do
    visit questions_path
    clear_emails
    click_on 'Registration'
  end

  describe 'Unregistered user' do

    background do
      fill_in 'user[email]', with: 'test_mail@test.com'
      fill_in 'user[password]', with: '12345678'
    end

    scenario 'try to sign up' do
      fill_in 'user[password_confirmation]', with: '12345678'
      click_on 'Sign up'

      expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
    end

    scenario 'confirm email' do
      fill_in 'user[password_confirmation]', with: '12345678'
      click_on 'Sign up'

      expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
      open_email('test_mail@test.com')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed'
    end


    scenario 'try to sign up with errors' do
      fill_in 'user[password_confirmation]', with: '12345678911'
      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end

  scenario 'Registered user try to sign up' do
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    fill_in 'user[password_confirmation]', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
