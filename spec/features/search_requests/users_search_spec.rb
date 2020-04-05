require 'sphinx_helper'

feature 'User can search for users.', %q(
"In order to find needed issue
 I'd like to be able to search for users."
) do
  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }

  describe 'Authenticated user' do
    background do
      sign_in(users.first)
      visit search_path
      select 'users', from: 'search[scope]'
    end

    scenario 'create user search request', js: true, sphinx: true do
      fill_in 'search[body]', with: users.first.email

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content 'Search results: 1'
        expect(page).to have_content 'Users search results:'
        expect(page).to have_content users.first.email
      end
    end

    scenario 'get correct search results', js: true, sphinx: true do
      fill_in 'search[body]', with: '@test.com'

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
      select 'users', from: 'search[scope]'
    end

    scenario 'create user search request', js: true, sphinx: true do
      fill_in 'search[body]', with: users.last.email

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content 'Search results: 1'
        expect(page).to have_content 'Users search results:'
        expect(page).to have_content users.last.email
      end
    end

    scenario 'get correct search results', js: true, sphinx: true do
      fill_in 'search[body]', with: '@test.com'

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content 'Search results: 2'
        expect(page).to_not have_content question.title
      end
    end
  end
end
