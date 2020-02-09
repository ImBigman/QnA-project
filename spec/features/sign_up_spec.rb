require 'rails_helper'

feature 'User can sign up', %q(
  "In order to ask questions or add answers
   As an unauthenticated user
   I'd like to able to sign up"
) do

  given(:user) { create(:user) }

  background do
    visit questions_path
    click_on 'Registration'
  end

  describe 'Unregistered user' do

    background do
      fill_in 'Email', with: 'test_mail@test.com'
      fill_in 'Password', with: '12345678'
    end

    scenario 'try to sign up' do
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'try to sign up with errors' do
      fill_in 'Password confirmation', with: '12345678911'
      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end

  scenario 'Registered user try to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
