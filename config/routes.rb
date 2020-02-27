Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions, shallow: true do
    resources :answers, shallow: true, only: %i[create destroy update] do
      member do
        patch :make_better
        put :make_better
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
end
