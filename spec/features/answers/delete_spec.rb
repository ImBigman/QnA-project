# TODO delete a answer
require 'rails_helper'

feature 'Author can delete a answer', %q(
"In order to delete a answer, as an owner
 I'd like to be able to delete answer"
) do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }

  background do
    @question = create(:question, author_id: user.id)
    @answer = create(:answer, question_id: @question.id, author_id: user.id)
  end

  describe 'Authenticated user' do
    scenario 'delete a question as author' do
      sign_in(user)
      visit question_path(@question)

      click_on 'Delete'

      expect(page).to have_content 'Your answer successfully deleted.'
    end

    scenario 'delete a answer as not author' do
      sign_in(user1)
      visit question_path(@question)

      click_on 'Delete'

      expect(page).to have_content "You can't delete not your question!"
    end
  end

  scenario 'Unauthenticated user try to delete a answer' do
    visit question_path(@question)

    click_on 'Delete'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
