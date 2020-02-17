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

  scenario 'Registered user try to sign in with valid password' do
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_on 'Login'

    expect(page).to have_content 'Signed in successfully.'
    expect(page).to_not have_content 'Sign in'
  end

  scenario 'Registered user try to sign in with invalid password' do
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: 'invalid password'
    click_on 'Login'

    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'Unregistered user try to sign in' do
    expect(page).to_not have_content 'Sign out'

    fill_in 'user[email]', with: 'wrong_user@test.com'
    fill_in 'user[password]', with: '12345678'
    click_on 'Login'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
