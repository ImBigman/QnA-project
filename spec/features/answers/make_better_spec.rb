require 'rails_helper'

feature 'Question author can choose the best answer', %q(
"In order to resolve a question problem
 I'd like to be able to choose the best answer"
) do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer1) { create(:answer, question: question, user: user1) }

  describe 'Choose the best' do
    scenario 'as question author', js: true do
      sign_in(user)
      visit question_path(question)
      within('.answers') do
        expect(page).to have_content answer.body
        expect(page).to have_content answer1.body
        expect(page.find('.row', match: :first).has_link?('Best', href: make_better_answer_path(answer))).to be true

        all('#answer-best').last.click

        expect(page.find('.row', match: :first).has_link?('Best', href: make_better_answer_path(answer1))).to be true
      end
    end

    scenario 'as no author', js: true do
      sign_in(user1)
      visit question_path(question)

      expect(page).to have_content answer.body
      expect(page).to have_content answer1.body
      expect(page.has_css?('#answer-best')).to be false
    end

    scenario 'as guest', js: true do
      visit question_path(question)

      expect(page).to have_content answer.body
      expect(page).to have_content answer1.body
      expect(page.has_css?('#answer-best')).to be false
    end
  end
end
