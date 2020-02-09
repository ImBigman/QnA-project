require 'rails_helper'

feature 'User can sign in', %q(
  "In order to ask questions
   As an unauthenticated user
   I'd like to able to sign in"
) do
  given(:user) { create(:user) }

  background do
    visit questions_path
    click_on 'Sign in'
  end

  scenario 'Registered user try to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user try to sign in' do
    fill_in 'Email', with: 'wrong_user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
