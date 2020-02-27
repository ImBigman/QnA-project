require 'rails_helper'

feature 'User can add links to question.', %q(
"In order to provide additional info into my question
 As an question author
 I'd like to be able to add links."
) do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/ImBigman/10e598d29412f5cc0a969ef02a34475b' }
  given(:gist_url1) { 'https://gist.github.com/ImBigman/8ca778b06a47e698bdbbb0b149f8dbdf' }


  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Title of question'
      fill_in 'Body', with: 'Body of question'
      fill_in 'Link name', with: 'My first gist'
    end

    describe 'add link' do
      background { fill_in 'Url', with: gist_url }

      scenario 'when ask questions' do
        click_on 'Save a question'

        expect(page).to have_link 'My first gist', href: gist_url
      end

      scenario 'and one more link when ask questions', js: true do
        page.find('a.add_fields').click

        expect(all('.nested-fields').count).to eq 2

        all('.question_links_name input').last.set('My second gist')
        all('.question_links_url input').last.set(gist_url1)

        click_on 'Save a question'

        expect(page).to have_link 'My first gist', href: gist_url
        expect(page).to have_link 'My second gist', href: gist_url1
      end

      scenario 'when ask questions with gist-embed area', js: true do
        click_on 'Save a question'

        expect(page).to have_css('.gist-data')
      end
    end

    scenario 'try add link with wrong format of url' do
      fill_in 'Url', with: 'foo'

      click_on 'Save a question'

      expect(page).to have_content 'please enter URL in correct format'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not add link when ask questions ' do
      visit questions_path
      click_on 'Ask question'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
