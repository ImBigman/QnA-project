require 'rails_helper'

feature 'User can delete links from answer.', %q(
"In order to correcting additional info into my answer
 As an answer author
 I'd like to be able to delete links."
) do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, :with_links, question: question, user: user) }

  scenario 'Guest can not delete a links into answer' do
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to have_link answer.links.first.name
    expect(page).to have_link answer.links.last.name
    expect(page).to_not have_css('#delete-attached-link')
  end

  scenario 'Authenticated user can not delete a links into answer as not an author' do
    sign_in(user1)

    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_css('#delete-attached-link')
    expect(page).to have_link answer.links.first.name
    expect(page).to have_link answer.links.last.name
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'delete a link', js: true do
      all('#delete-attached-link').first.click

      expect(page).to_not have_link answer.links.first.name
      expect(page).to have_link answer.links.last.name
    end
  end
end
