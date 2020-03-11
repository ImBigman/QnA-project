require 'rails_helper'

feature 'User can add comment to answer.', %q(
"In order to request additional information from answer author
 I'd like to be able to add comment."
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer1) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add comment for answer', js: true do
      within '.answers' do
        expect(page).to have_css('.empty')

        all('a#answer-comment').first.click
        fill_in 'comment[body]', with: 'This is test comment for answer'
        click_on 'save comment'

        expect(page).to have_content 'This is test comment for answer'
      end
    end

    scenario 'can not add comment with invalid attributes', js: true do
      within '.answers' do
        expect(page).to have_css('.empty')

        all('a#answer-comment').first.click
        fill_in 'comment[body]', with: ''
        click_on 'save comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'multiple sessions' do
    scenario "answer comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do

          all('a#answer-comment').first.click
          fill_in 'comment[body]', with: 'This is test comment for answer'
          click_on 'save comment'

          expect(page).to have_content 'This is test comment for answer'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'This is test comment for answer'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not add comment' do
      visit question_path(question)

      expect(page).to_not have_css('#answer-comment')
    end
  end
end
