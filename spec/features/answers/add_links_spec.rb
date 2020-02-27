require 'rails_helper'

feature 'User can add links to answer.', %q(
"In order to provide additional info into my answer
 As an question author
 I'd like to be able to add links."
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/ImBigman/dda79be999f888873be0200c5802d97f' }
  given(:gist_url1) { 'https://gist.github.com/ImBigman/8ca778b06a47e698bdbbb0b149f8dbdf' }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'answer[body]', with: 'This is test answer for some question'
      fill_in 'Link name', with: 'My first gist'
    end

    describe 'can add link' do
      background { fill_in 'Url', with: gist_url }

      scenario 'when give an answer', js: true do
        click_on 'Add a answer'

        within '.answers' do
          expect(page).to have_link 'My first gist', href: gist_url
        end
      end

      scenario 'and one more link when give an answer', js: true do
        page.find('a.add_fields').click

        expect(all('.nested-fields').count).to eq 2

        all('.answer_links_name input').last.set('My second gist')
        all('.answer_links_url input').last.set(gist_url1)

        click_on 'Add a answer'

        expect(page).to have_link 'My first gist', href: gist_url
        expect(page).to have_link 'My second gist', href: gist_url1
      end

      scenario 'when give an answers with gist-embed area', js: true do
        click_on 'Add a answer'

        expect(page).to have_css('.gist-data')
      end
    end

    scenario 'try add link with wrong format of url', js: true do
      fill_in 'Url', with: 'foo'

      click_on 'Add a answer'

      expect(page).to have_content 'please enter URL in correct format'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not add link when give an answer' do
      visit question_path(question)

      expect(page).to_not have_css('.nested-fields')
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
