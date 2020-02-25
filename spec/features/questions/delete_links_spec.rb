require 'rails_helper'

feature 'User can delete links from question.', %q(
"In order to correcting additional info into my question
 As an question author
 I'd like to be able to delete links."
) do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, :with_files, :with_links, user: user) }
  given(:link) { create(:link, name: 'Third', url: 'https://yandex.ru', linkable: question) }

  scenario 'Guest can not delete a links into question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_link question.links.first.name
    expect(page).to have_link question.links.last.name
    expect(page).to_not have_css('#delete-attached-link')
  end

  scenario 'Authenticated user can not delete a links into question as not an author' do
    sign_in(user1)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to_not have_css('#delete-attached-link')
    expect(page).to have_link question.links.first.name
    expect(page).to have_link question.links.last.name
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'delete a link', js: true do
      all('#delete-attached-link').first.click

      expect(page).to_not have_link question.links.first.name
      expect(page).to have_link question.links.last.name
    end
  end
end
