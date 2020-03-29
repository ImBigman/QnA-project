require 'rails_helper'

feature 'User can unsubscribe to question.', %q(
"In order to stop following the question
 I'd like to be able to unsubscribe to the question."
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:sub) { create(:subscription, user_id: user.id, question_id: question.id) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'unsubscribe from the question', js: true do
      expect(page).to have_css('.subscriptions #mark-enabled')

      find('.octicon-bookmark').click
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_css('.subscriptions #mark-disabled')
    end
  end

  describe 'Unauthenticated user', js: true do
    background { visit question_path(question) }

    scenario 'can not unsubscribe from the question' do
      expect(page).to_not have_css('.subscriptions #mark-enabled')
      expect(page).to have_css('.subscriptions #mark-disabled')
    end
  end
end

