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
end
