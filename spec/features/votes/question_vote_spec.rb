require 'rails_helper'

feature 'User can vote for a question', %q(
"In order to solve my problem
 I'd like to be able to vote on a question, making it more popular"
) do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Vote', js: true do
    background do
      sign_in(user1)
      visit question_path(question)
    end

    scenario 'for a question as not an author' do
      within '.question' do
        expect(find('#vote-score')).to have_content '0'
        all('a#vote-for').first.click
      end

      expect(page).to have_content '1'
    end

    scenario 'against a question as not an author' do
      within '.question' do
        expect(find('#vote-score')).to have_content '0'
        all('a#vote-against').first.click
      end

      expect(page).to have_content '-1'
    end
  end

  describe 'Vote', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'on behalf of the author is prohibited' do
      within '.question' do
        expect(find('#vote-score')).to have_content '0'
        expect(page).to_not have_css('a#vote-for')
        expect(page).to_not have_css('a#vote-against')
        expect(page).to have_css('#for-disabled')
        expect(page).to have_css('#against-disabled')
      end
    end

    scenario 'on behalf of the guest is prohibited' do
      within '.question' do
        expect(find('#vote-score')).to have_content '0'
        expect(page).to_not have_css('a#vote-for')
        expect(page).to_not have_css('a#vote-against')
        expect(page).to have_css('#for-disabled')
        expect(page).to have_css('#against-disabled')
      end
    end
  end

  describe 'Vote', js: true do
    background do
      sign_in(user1)
      visit question_path(question)
    end

    scenario 'for a question not as an author one more time' do
      within '.question' do
        expect(find('#vote-score')).to have_content '0'
        all('a#vote-for').first.click

        expect(find('#vote-score')).to have_content '1'
        all('a#vote-for').first.click
      end

      expect(page).to have_content '1'
    end

    scenario 'against a question not as an author one more time' do
      within '.question' do
        expect(find('#vote-score')).to have_content '0'
        all('a#vote-against').first.click
        all('a#vote-against').first.click
      end

      expect(page).to have_content '-1'
    end

    describe 'You completely change your opinion' do
      given!(:vote) { create(:vote, user_id: user1.id, votable: question, score: -1) }

      scenario 'from negative to positive' do
        within '.question' do
          all('a#vote-for').first.click

          expect(find('#vote-score')).to have_content '0'
          all('a#vote-for').first.click

          expect(find('#vote-score')).to have_content '1'
        end
      end
    end
  end
end
