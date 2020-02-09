 require 'rails_helper'

 feature 'Author can delete a questions', %q(
"In order to delete a question, as an owner
 I'd like to be able to delete question"
) do
   given(:user) { create(:user) }
   given(:user1) { create(:user) }
   given(:question) { create(:question, author_id: user.id) }

   describe 'Authenticated user' do
     scenario 'delete a question as author' do
       sign_in(user)
       visit question_path(question)
       expect(page).to have_content "from: #{user.email}"

       click_on 'Delete a question'

       expect(page).to have_content 'successfully deleted.'
     end

     scenario 'delete a question as not author' do
       sign_in(user1)
       visit question_path(question)
       click_on 'Delete a question'

       expect(page).to have_content "You can't delete not your question!"
     end
   end

   scenario 'Unauthenticated user try to ask a question ' do
     visit question_path(question)
     click_on 'Delete a question'

     expect(page).to have_content 'You need to sign in or sign up before continuing.'
   end
 end
