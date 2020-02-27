require 'rails_helper'

feature 'User can edit his question', %q(
"In order to correct mistakes
 As an author of question
 I'd like to be able to edit my question"
) do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, :with_files, :with_links, user: user) }
  given(:link) { create(:link, name: 'Third', url: 'https://yandex.ru', linkable: question) }

  scenario 'Guest can not edit a question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to_not have_css('#question-edit')
  end

  scenario 'Authenticated user can not edit the question as not an author', js: true do
    sign_in(user1)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to_not have_css('#question-edit')
    expect(page).to have_link 'feature_helpers.rb'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
      page.find('#question-edit').click
    end

    scenario 'edit a question', js: true do
      fill_in 'question[title]', with: 'edited question title'
      fill_in 'question[body]', with: 'edited question body'
      click_on 'Save'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question title'
      expect(page).to_not have_selector 'text_area'
    end

    scenario 'can attach files', js: true do
      within '#edit-question' do
        attach_file 'question[files][]', ["#{Rails.root}/spec/support/feature_helpers.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'feature_helpers.rb'
    end
    scenario 'can delete any attached files', js: true do
      within '#edit-question' do
        page.find(".attached-file-#{question.files.first.id} #delete-attached-file").click
        click_on 'Save'
      end

      within '.question-files' do
        expect(page).to_not have_link 'feature_helpers.rb'
        expect(page).to have_link 'controller_helpers.rb'
      end
    end

    scenario 'can add link', js: true do
      within '.question-edit-form' do
        expect(page).to have_field('Link name', with: question.links.first.name)
        expect(page).to have_field('Url', with: question.links.first.url)
        all('.question_links_name input').last.set(link.name)
        all('.question_links_url input').last.set(link.url)

        click_on 'Save'
      end

      expect(page).to have_link  link.name, href: link.url
      expect(page).to have_link  question.links.first.name, href: question.links.first.url
      expect(page).to have_link  question.links.last.name, href: question.links.last.url
    end

    scenario 'can delete any link', js: true do
      within '.question-edit-form' do
        all('.octicon-dash').first.click
        click_on 'Save'
      end

      within '.question' do
        expect(page).to_not have_link question.links.first.name, href: question.links.first.url
        expect(page).to have_link question.links.last.name, href: question.links.last.url
      end
    end
  end
end

