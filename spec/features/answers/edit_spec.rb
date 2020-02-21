require 'rails_helper'

feature 'User can edit his answer', %q(
"In order to correct mistakes
 As an author of answer
 I'd like to be able to edit my answer"
) do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, :with_files, question: question, user: user) }

  scenario 'Guest can not edit the answer', js: true do
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

      within '.answers' do
        click_on 'Edit'
      end
    end

    scenario 'can edit the answer', js: true do
      within '.answers' do
        fill_in 'answer[body]', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'text_area'
      end
    end

    scenario 'can attach files', js: true do
      within '.answers' do
        attach_file 'answer[files][]', ["#{Rails.root}/spec/support/feature_helpers.rb"]
        click_on 'Save'

        expect(page).to have_link 'feature_helpers.rb'
      end
    end

    scenario 'can delete any attached files', js: true do
      within '.answers' do
        page.find(".attached-file-#{answer.files.first.id} #delete-attached-file").click
        click_on 'Save'

        expect(page).to_not have_link 'feature_helpers.rb'
        expect(page).to have_link 'controller_helpers.rb'
      end
    end
  end
end
