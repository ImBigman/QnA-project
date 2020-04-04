require 'sphinx_helper'

feature 'User can search for answer.', %q(
"In order to find needed issue
 I'd like to be able to search for answer."
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit search_path
      select 'answers', from: 'search[scope]'
    end

    scenario 'create answer search request', js: true, sphinx: true do
      fill_in 'search[body]', with: answers.first.body

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content 'Search results: 1'
        expect(page).to have_content 'Answers search results:'
        expect(page).to have_content answers.first.body
      end
    end

    scenario 'get correct search results', js: true, sphinx: true do
      fill_in 'search[body]', with: 'This is test answer'

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content 'Search results: 2'
        expect(page).to_not have_content question.title
      end
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit search_path
      select 'answers', from: 'search[scope]'
    end

    scenario 'create answer search request', js: true, sphinx: true do
      fill_in 'search[body]', with: answers.last.body

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content 'Search results: 1'
        expect(page).to have_content 'Answers search results:'
        expect(page).to have_content answers.last.body
      end
    end

    scenario 'get correct search results', js: true, sphinx: true do
      fill_in 'search[body]', with: 'This is test answer'

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content 'Search results: 2'
        expect(page).to_not have_content question.title
      end
    end
  end
end
