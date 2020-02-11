require 'rails_helper'

feature 'The user can view a list of all questions.', %q(
"In order to find answer from a community
 I'd like to be able to see list of all question"
) do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2, user: user) }

  background { visit questions_path }

  scenario 'Visit the main page for looking a list of all questions' do
    expect(page).to have_css '.title'
    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.last.title
  end
end
