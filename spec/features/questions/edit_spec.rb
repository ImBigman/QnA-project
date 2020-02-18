require 'rails_helper'

feature 'User can edit his question', %q(
"In order to correct mistakes
 As an author of question
 I'd like to be able to edit my question"
) do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Guest can not edit a question', js: true do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to_not have_css('#question-edit')
  end

  scenario 'Authenticated user can not edit the question as not an author', js: true do
    sign_in(user1)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to_not have_css('#question-edit')
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
      page.find('#question-edit').click
    end

    scenario 'edit a question', js: true do
      fill_in 'question[title]', with: 'edited question title'
      fill_in 'question[body]', with: 'edited question body'
      click_on 'Save'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question title'
      expect(page).to_not have_selector 'text_area'
    end

    scenario 'can attach files', js: true do
      within '#edit-question' do
        attach_file 'question[files][]', ["#{Rails.root}/spec/support/feature_helpers.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'feature_helpers.rb'
    end
  end
end

