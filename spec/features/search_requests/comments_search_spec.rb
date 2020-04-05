require 'sphinx_helper'

feature 'User can search for comment.', %q(
"In order to find needed issue
 I'd like to be able to search for comment."
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:comments) { create_list(:comment, 2, commentable: question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit search_path
      select 'comments', from: 'search[scope]'
    end

    scenario 'create comment search request', js: true, sphinx: true do
      fill_in 'search[body]', with: comments.first.body

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content 'Search results: 1'
        expect(page).to have_content 'Comments search results:'
        expect(page).to have_content comments.first.body
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
      select 'comments', from: 'search[scope]'
    end

    scenario 'create comment search request', js: true, sphinx: true do
      fill_in 'search[body]', with: comments.last.body

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content 'Search results: 1'
        expect(page).to have_content 'Comments search results:'
        expect(page).to have_content comments.last.body
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
