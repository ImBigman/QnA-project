require 'rails_helper'

feature 'User can sign out', %q(
  "In order to close session
   As an unauthenticated user
   I'd like to able to sign out"
) do
  given(:user) { create(:user) }

  scenario 'user try to sign out' do
    sign_in(user)
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
