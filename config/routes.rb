require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', confirmations: 'confirmations' }

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
    resources :subscriptions, shallow: true, only: %i[create destroy]
  end

  namespace :api do
    namespace :v1 do
      resource :profiles, only: [] do
        get :me, on: :collection
        get :other_users, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit], shallow: true
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  get 'search', to: 'search#index'
  post 'search', to: 'search#searching'

  mount ActionCable.server => '/cable'
end
