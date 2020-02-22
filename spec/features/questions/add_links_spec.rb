require 'rails_helper'

feature 'User can add links to question.', %q(
"In order to provide additional info into my question
 As an question author
 I'd like to be able to add links."
) do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/ImBigman/dda79be999f888873be0200c5802d97f' }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User can add link when ask questions' do
    fill_in 'Title', with: 'Title of question'
    fill_in 'Body', with: 'Body of question'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Save a question'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
