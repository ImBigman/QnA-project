require 'sphinx_helper'

feature 'User can search for question.', %q(
"In order to find needed issue
 I'd like to be able to search for question."
) do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2, user: user) }
  given!(:answer) { create(:answer, question: questions.first, user: user, body: 'Its test question #1 answer') }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit search_path
      select 'questions', from: 'search[scope]'
    end

    scenario 'create question search request', js: true, sphinx: true do
      fill_in 'search[body]', with: questions.first.title

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content 'Search results: 1'
        expect(page).to have_content 'Questions search results:'
        expect(page).to have_content questions.first.title
      end
    end

    scenario 'get correct search results', js: true, sphinx: true do
      fill_in 'search[body]', with: 'Its test question #'

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content 'Search results: 2'
        expect(page).to_not have_content answer.body
      end
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit search_path
      select 'questions', from: 'search[scope]'
    end

    scenario 'create question search request', js: true, sphinx: true do
      fill_in 'search[body]', with: questions.last.title

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content 'Search results: 1'
        expect(page).to have_content 'Questions search results:'
        expect(page).to have_content questions.last.title
      end
    end

    scenario 'get correct search results', js: true, sphinx: true do
      fill_in 'search[body]', with: 'Its test question #'

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content 'Search results: 2'
        expect(page).to_not have_content answer.body
      end
    end
  end
end
