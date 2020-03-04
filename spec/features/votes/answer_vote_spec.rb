require 'rails_helper'

feature 'User can vote for a answer', %q(
"In order to show more helpful for me resolve
 I'd like to be able to vote on a answer"
) do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Vote', js: true do
    background do
      sign_in(user1)
      visit question_path(question)
    end

    scenario 'for a answer as not an author' do
      within '.answers' do
        expect(all('#vote-score').first).to have_content '0'
        all('a#vote-for').first.click
      end

      expect(page).to have_content '1'
    end

    scenario 'against a answer as not an author' do
      within '.answers' do
        expect(all('#vote-score').first).to have_content '0'
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
      within '.answers' do
        expect(find('#vote-score')).to have_content '0'
        expect(page).to_not have_css('a#vote-for')
        expect(page).to_not have_css('a#vote-against')
        expect(page).to have_css('#for-disabled')
        expect(page).to have_css('#against-disabled')
      end
    end

    scenario 'on behalf of the guest is prohibited' do
      within '.answers' do
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

    scenario 'for a answer as not an author one more time' do
      within '.answers' do
        expect(all('#vote-score').first).to have_content '0'
        all('a#vote-for').first.click

        expect(find('#vote-score')).to have_content '1'
        all('a#vote-for').first.click
      end

      expect(page).to have_content '1'
    end

    scenario 'against a answer as not an author one more time' do
      within '.answers' do
        expect(find('#vote-score')).to have_content '0'
        all('a#vote-against').first.click
        all('a#vote-against').first.click
      end

      expect(page).to have_content '-1'
    end

    describe 'You completely change your opinion' do
      given!(:vote) { create(:vote, user_id: user1.id, votable: answer, score: -1) }

      scenario 'from negative to positive' do
        within '.answers' do
          all('a#vote-for').first.click

          expect(find('#vote-score')).to have_content '0'
          all('a#vote-for').first.click

          expect(find('#vote-score')).to have_content '1'
        end
      end
    end
  end
end

