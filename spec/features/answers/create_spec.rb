require 'rails_helper'

feature 'User can create answer of the question', %q(
"To help with the issue of the question
 As an authenticated user
 I'd like to be able to add an answer"
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'write a answer', js: true do
      fill_in 'answer[body]', with: 'This is test answer for some question'
      click_on 'Add a answer'

      within('.answers') do
        expect(page).to have_text('This is test answer for some question')
      end

      expect(current_path).to eq question_path(question)
    end

    scenario 'write a answer with errors', js: true do
      click_on 'Add a answer'

      expect(page).to have_content "Body can't be blank"
      expect(current_path).to eq question_path(question)
    end
  end

  scenario 'Unauthenticated user try write a answer ' do
    visit question_path(question)

    click_on 'Add a answer'

    expect(current_path).to eq new_user_session_path
  end
end
