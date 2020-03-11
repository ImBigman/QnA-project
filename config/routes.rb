Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  concern :votable do
    member do
      patch :positive_vote
      patch :negative_vote
    end
  end

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, shallow: true, concerns: %i[votable commentable] do
    resources :answers, shallow: true, only: %i[create destroy update], concerns: %i[votable commentable] do
      member do
        patch :make_better
        put :make_better
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
