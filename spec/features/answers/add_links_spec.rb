require 'rails_helper'

feature 'User can add links to answer.', %q(
"In order to provide additional info into my answer
 As an question author
 I'd like to be able to add links."
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/ImBigman/dda79be999f888873be0200c5802d97f' }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User can add link when give an answer', js: true do
    fill_in 'answer[body]', with: 'This is test answer for some question'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add a answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
