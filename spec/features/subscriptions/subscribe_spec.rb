require 'rails_helper'

feature 'User can subscribe to question.', %q(
"In order to get the latest community response
 I'd like to be able to subscribe to the question."
) do
  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, user: users.first) }

  describe 'Authenticated user' do
    background do
      sign_in(users.last)
      visit question_path(question)
    end

    scenario 'subscribe to the question', js: true do
      expect(page).to have_css('.subscriptions #mark-disabled')

      find('.octicon-bookmark').click

      expect(page).to have_css('.subscriptions #mark-enabled')
    end
  end

  describe 'Unauthenticated user', js: true do
    background { visit question_path(question) }

    scenario 'can not subscribe to the question' do
      expect(page).to have_css('.subscriptions #mark-disabled')

      find('.octicon-bookmark').click

      expect(page).to_not have_css('.subscriptions #mark-enabled')
    end
  end
end
