require 'rails_helper'

feature 'User can edit his answer', %q(
"In order to correct mistakes
 As an author of answer
 I'd like to be able to edit my answer"
) do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, :with_files, :with_links, question: question, user: user) }
  given(:link) { create(:link, name: 'Third', url: 'https://yandex.ru', linkable: question) }

  scenario 'Guest can not edit the answer', js: true do
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_content 'Edit'
  end

  scenario 'Authenticated user can not edit the answer as not an author', js: true do
    sign_in(user1)

    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_content 'Edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
      end
    end

    scenario 'can edit the answer', js: true do
      within '.answers' do
        fill_in 'answer[body]', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'text_area'
      end
    end

    scenario 'can attach files', js: true do
      within '.answers' do
        attach_file 'answer[files][]', ["#{Rails.root}/spec/support/feature_helpers.rb"]
        click_on 'Save'

        expect(page).to have_link 'feature_helpers.rb'
      end
    end

    scenario 'can delete any attached files', js: true do
      within '.answers' do
        page.find(".attached-file-#{answer.files.first.id} #delete-attached-file").click
        click_on 'Save'

        expect(page).to_not have_link 'feature_helpers.rb'
        expect(page).to have_link 'controller_helpers.rb'
      end
    end

    scenario 'can add link', js: true do
      within '.answers' do
        expect(page).to have_field('Link name', with: answer.links.first.name)
        expect(page).to have_field('Url', with: answer.links.first.url)
        all('.answer_links_name input').last.set(link.name)
        all('.answer_links_url input').last.set(link.url)

        click_on 'Save'
      end

      expect(page).to have_link  link.name, href: link.url
      expect(page).to have_link  answer.links.first.name, href: answer.links.first.url
      expect(page).to have_link  answer.links.last.name, href: answer.links.last.url
    end

    scenario 'can delete any link', js: true do
      within '.answers' do
        all('.octicon-dash').first.click
        click_on 'Save'
      end

      within '.answers' do
        expect(page).to_not have_link answer.links.first.name, href: answer.links.first.url
      end
    end
  end
end
