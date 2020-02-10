require 'rails_helper'

feature 'The user can view a list of all questions and go to the page of the selected question.', %q(
"In order to find answer from a community
 I'd like to be able to see list of all question
 I'd like to be able to go to the page of the selected question"
) do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  background { visit questions_path }

  scenario 'Visit the main page for looking a list of all questions' do
    expect(page).to have_css '.title'
  end

  scenario 'Clicking on the title of the question should redirect to the chosen question page' do
    find('.question_link', match: :first).click

    expect(page).to have_content "from: #{user.email}"
    expect(page).to have_content 'Its test question body'
  end
end
