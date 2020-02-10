 require 'rails_helper'

 feature 'Author can delete a questions', %q(
"In order to delete a question, as an owner
 I'd like to be able to delete question"
) do
   given(:user) { create(:user) }
   given(:question) { create(:question, user: user) }
   given!(:question1) { create(:question, user: user) }

   describe 'Authenticated user' do
     scenario 'delete a question as author' do
       sign_in(user)
       visit question_path(question)
       expect(page).to have_content "from: #{user.email}"

       click_on 'Delete a question'

       expect(page).to have_content "Your question '#{question.title[0..-2]}' successfully deleted."
       expect(page).to_not have_content question.title
     end
   end
 end
