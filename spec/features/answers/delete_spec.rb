require 'rails_helper'

feature 'Author can delete a answer', %q(
"In order to delete a answer, as an owner
 I'd like to be able to delete answer"
) do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    scenario 'delete a answer as author', js: true do
      sign_in(user)
      visit question_path(question)
      expect(page).to have_content answer.body

      page.find('#answer_delete').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to_not have_content answer.body
    end

    scenario 'as not an author' do
      sign_in(user1)
      visit question_path(question)
      expect(page).to have_content "from: #{user.email}"
      expect(page).to have_content answer.body
      expect(page).to_not have_content 'Delete'
    end
  end

  describe 'Guest' do
    scenario 'cannot delete the answer' do
      visit question_path(question)
      expect(page).to have_content "from: #{user.email}"
      expect(page).to have_content question.title
      expect(page).to_not have_content 'Delete'
    end
  end
end
