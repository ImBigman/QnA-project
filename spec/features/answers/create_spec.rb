require 'rails_helper'

feature 'User can create answer of the question', %q(
"To help with the issue of the question
 As an authenticated user
 I'd like to be able to add an answer"
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    describe 'write' do
      background { fill_in 'answer[body]', with: 'This is test answer for some question' }

      scenario 'a answer', js: true do
        click_on 'Add a answer'

        within('.answers') { expect(page).to have_text('This is test answer for some question') }

        expect(current_path).to eq question_path(question)
      end

      scenario 'a answer with attached files', js: true do
        attach_file 'answer[files][]', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb" ]
        click_on 'Add a answer'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'write a answer with errors', js: true do
      click_on 'Add a answer'

      expect(page).to have_content "Body can't be blank"
      expect(current_path).to eq question_path(question)
    end
  end

  scenario 'Unauthenticated user try write a answer ' do
    visit question_path(question)

    expect(page).to have_link('Add a answer', href: '')
  end

  describe 'multiple sessions' do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'answer[body]', with: 'This is test answer for some question'
        click_on 'Add a answer'

        expect(page).to have_content 'This is test answer for some question'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'This is test answer for some question'
      end
    end
  end
end
