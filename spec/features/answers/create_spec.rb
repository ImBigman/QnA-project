require 'rails_helper'

feature 'User can create answer of the question', %q(
"To help with the issue of the question
 As an authenticated user
 I'd like to be able to add an answer"
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, author_id: user.id) }

  describe 'Authenticated user' do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'write a answer' do
      fill_in 'answer[body]', with: 'This is test answer for some question'
      click_on 'Add a answer'

      expect(page).to have_content 'Your answer has been successfully added.'
      expect(page).to have_content 'This is test answer for some question'
    end

    scenario 'write a answer with errors' do
      click_on 'Add a answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user try write a answer ' do
    visit question_path(question)
    click_on 'Add a answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
