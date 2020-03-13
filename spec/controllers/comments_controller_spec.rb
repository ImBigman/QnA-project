require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create :answer, question: question, user: user, best: false }

  describe 'POST #create' do
    context 'As user' do
      before { login(user) }

      context 'for question' do
        context 'with correct attributes' do
          it 'create comment' do
            expect { post :create, params: { comment: attributes_for(:comment), question_id: question, format: :js } }
              .to change(Comment, :count).by(1)
          end

          it 'comment saves with correct question' do
            post :create, params: { comment: attributes_for(:comment), question_id: question, format: :js }
            expect(assigns(:comment).commentable).to eq(question)
          end

          it 'comment saves with correct author' do
            post :create, params: { comment: attributes_for(:comment), question_id: question, format: :js }
            expect(assigns(:comment).user).to eq(user)
          end

          it 'render create view' do
            post :create, params: { comment: attributes_for(:comment), question_id: question, format: :js }
            expect(response).to render_template :create
            expect(response).to have_http_status :ok
          end

          it 'streaming to channel' do
            expect do
              post :create, params: { comment: attributes_for(:comment), question_id: question, format: :js }
            end.to broadcast_to("question_#{question.id}_comments").with(a_hash_including(author: user.email))
          end
        end

        context 'with invalid attributes' do
          it 'does not save the comment' do
            expect { post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question, format: :js } }
              .to_not change(Comment, :count)
          end

          it 're-render create view' do
            post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question, format: :js }
            expect(response).to render_template :create
            expect(response).to have_http_status :ok
          end

          it 'do not streaming to channel' do
            expect do
              post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question, format: :js }
            end.to_not broadcast_to("question_#{question.id}_comments")
          end
        end
      end

      context 'for answer' do
        context 'with correct attributes' do
          it 'create comment' do
            expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer, format: :js } }
              .to change(Comment, :count).by(1)
          end

          it 'comment saves with correct question' do
            post :create, params: { comment: attributes_for(:comment), answer_id: answer, format: :js }
            expect(assigns(:comment).commentable).to eq(answer)
          end

          it 'comment saves with correct author' do
            post :create, params: { comment: attributes_for(:comment), answer_id: answer, format: :js }
            expect(assigns(:comment).user).to eq(user)
          end

          it 'render create view' do
            post :create, params: { comment: attributes_for(:comment), answer_id: answer, format: :js }
            expect(response).to render_template :create
            expect(response).to have_http_status :ok
          end

          it 'streaming to channel' do
            expect do
              post :create, params: { comment: attributes_for(:comment), answer_id: answer, format: :js }
            end.to broadcast_to("question_#{question.id}_comments").with(a_hash_including(author: user.email))
          end
        end

        context 'with invalid attributes' do
          it 'does not save the comment' do
            expect { post :create, params: { comment: attributes_for(:comment, :invalid), answer_id: answer, format: :js } }
              .to_not change(Comment, :count)
          end

          it 're-render create view' do
            post :create, params: { comment: attributes_for(:comment, :invalid), answer_id: answer, format: :js }
            expect(response).to render_template :create
            expect(response).to have_http_status :ok
          end

          it 'do not streaming to channel' do
            expect do
              post :create, params: { comment: attributes_for(:comment, :invalid), answer_id: answer, format: :js }
            end.to_not broadcast_to("question_#{question.id}_comments")
          end
        end
      end
    end

    context 'As guest' do
      it 'does not create the comment for resource' do
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question, format: :js } }.not_to change(question.links, :count)
      end

      it 'responds with 401' do
        post :create, params: { comment: attributes_for(:comment), question_id: question, format: :js }
        expect(response).to have_http_status :unauthorized
      end

      it 'redirect to sign in page' do
        post :create, params: { comment: attributes_for(:comment), question_id: question }

        expect(response.status).to eq 302
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
