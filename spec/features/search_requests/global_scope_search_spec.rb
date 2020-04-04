require 'sphinx_helper'

feature 'User can search for all resources.', %q(
"In order to find needed issue
 I'd like to be able to search for all resources."
) do
  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }
  given!(:answer) { create(:answer, question: question, user: users.first) }
  given!(:comment) { create(:comment, commentable: question, user: users.first) }

  describe 'Authenticated user' do
    background do
      sign_in(users.first)
      visit search_path
      select 'global', from: 'search[scope]'
    end

    scenario 'create global scope search request', js: true, sphinx: true do
      fill_in 'search[body]', with: users.first.email

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content 'Search results: 4'
        expect(page).to have_content 'Global search results:'
      end
    end

    scenario 'get correct search results', js: true, sphinx: true do
      fill_in 'search[body]', with: users.first.email

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content question.title
        expect(page).to have_content answer.body
        expect(page).to have_content comment.body
        expect(page).to have_content users.first.email
      end
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit search_path
      select 'global', from: 'search[scope]'
    end

    scenario 'create global scope search request', js: true, sphinx: true do
      fill_in 'search[body]', with: users.first.email

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content 'Search results: 4'
        expect(page).to have_content 'Global search results:'
      end
    end

    scenario 'get correct search results', js: true, sphinx: true do
      fill_in 'search[body]', with: users.first.email

      ThinkingSphinx::Test.run do
        page.find('#search-button').click

        expect(page).to have_content question.title
        expect(page).to have_content answer.body
        expect(page).to have_content comment.body
        expect(page).to have_content users.first.email
      end
    end
  end
end
