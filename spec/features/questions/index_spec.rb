require 'rails_helper'

feature 'The user can view a list of all questions and go to the page of the selected question.', %q(
"In order to find answer from a community
 I'd like to be able to see list of all question
 I'd like to be able to go to the page of the selected question"
) do
  background do
    question1 = create(:question)
    question2 = create(:question)
    question3 = create(:question)
    answer1 = create(:answer, question: question1)
    answer2 = create(:answer, question: question1)
    answer3 = create(:answer, question: question2)

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
