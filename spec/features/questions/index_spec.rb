require 'rails_helper'

feature 'The user can view a list of all questions and go to the page of the selected question.', %q(
"In order to find answer from a community
 I'd like to be able to see list of all question
 I'd like to be able to go to the page of the selected question"
) do
  given(:user) { create(:user) }

  background do
    question1 = create(:question, author_id: user.id)
    question2 = create(:question, author_id: user.id)
    question3 = create(:question, author_id: user.id)
    answer1 = create(:answer, question: question1, author_id: user.id)
    answer2 = create(:answer, question: question1, author_id: user.id)
    answer3 = create(:answer, question: question2, author_id: user.id)

    visit questions_path
  end

  scenario 'Visit the main page for looking a list of all questions' do
    expect(page).to have_css '.title'
    expect(page).to have_css '.answers'
  end

  scenario 'Clicking on the title of the question should redirect to the chosen question page' do
    find('.question_link', match: :first).click

    expect(page).to have_content 'Its test question '
    expect(page).to have_content 'Its test question body'
  end
end
