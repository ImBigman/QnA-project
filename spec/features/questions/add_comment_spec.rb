require 'rails_helper'

feature 'User can add comment to question.', %q(
"In order to request additional information from question author
 I'd like to be able to add comment."
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add comment for question', js: true do
      expect(page).to have_content "0 comment's"

      click_on 'add comment'
      fill_in 'comment[body]', with: 'This is test comment for question'
      click_on 'save comment'

      expect(page).to have_content 'This is test comment for question'
    end

    scenario 'can not add comment with invalid attributes', js: true do
      expect(page).to have_content "0 comment's"

      click_on 'add comment'
      fill_in 'comment[body]', with: ' '
      click_on 'save comment'

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'multiple sessions' do
    scenario "question comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question' do

          find('a#question-comment').click
          fill_in 'comment[body]', with: 'This is test comment for answer'
          click_on 'save comment'

          expect(page).to have_content 'This is test comment for answer'
        end
      end

      Capybara.using_session('guest') do
        within '.question' do
          expect(page).to have_content 'This is test comment for answer'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not add comment' do
      visit question_path(question)

      expect(page).to_not have_css('#question-comment')
    end
  end
end
