# TODO delete a answer
require 'rails_helper'

feature 'Author can delete a answer', %q(
"In order to delete a answer, as an owner
 I'd like to be able to delete answer"
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    scenario 'delete a question as author' do
      sign_in(user)

      visit question_path(question)

      expect(page).to have_content answer.body

      page.find('#answer_delete').click

      expect(page).to have_content 'Your answer successfully deleted.'
      expect(page).to_not have_content answer.body
    end
  end
end
