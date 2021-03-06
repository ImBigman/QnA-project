require 'rails_helper'

feature 'User can create a questions', %q(
"In order to get answer from a community
 As an authenticated user
 I'd like to be able to ask the question"
) do
  given(:user) { create(:user) }

  describe 'Authenticated user' do

    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    describe 'ask a' do

      background do
        fill_in 'Title', with: 'Title of question'
        fill_in 'Body', with: 'Body of question'
      end

      scenario 'question' do
        click_on 'Save a question'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Title of question'
        expect(page).to have_content 'Body of question'
      end

      scenario 'question with attached files' do
        attach_file 'question[files][]', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb" ]
        click_on 'Save a question'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'question with reward' do
        fill_in 'Reward title', with: 'For the best answer'
        attach_file 'question[reward_attributes][image]', 'app/assets/images/cup-icon.png'
        click_on 'Save a question'

        expect(page).to have_css('.question-reward')
        expect(page.find('.reward-image')['src']).to have_content 'cup-icon.png'
      end
    end

    scenario 'ask a question with errors' do
      click_on 'Save a question'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user try to ask a question ' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  describe 'multiple sessions' do
    scenario "question appears on another user's page",  js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'Title', with: 'Title of question'
        fill_in 'Body', with: 'Body of question'
        click_on 'Save a question'

        expect(page).to have_content 'Title of question'
        expect(page).to have_content 'Body of question'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Title of question'
      end
    end
  end
end
