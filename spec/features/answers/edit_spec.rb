require 'rails_helper'

feature 'User can edit his answer', %q(
"In order to correct mistakes
 As an author of answer
 I'd like to be able to edit my answer"
) do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Guest can not edit a answer', js: true do
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_content 'Edit'
  end

  scenario 'Authenticated user can not edit the answer as not an author', js: true do
    sign_in(user1)

    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_content 'Edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'edit a answer', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'answer[body]', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'text_area'
      end
    end
  end
end

