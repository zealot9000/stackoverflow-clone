Rails.application.routes.draw do

root to: "questions#index"
  devise_for :users

  resources :questions do
    resources :answers, shallow: true do
      member do
        patch :mark_best
      end
    end
  end

  resources :attachments, only: [:destroy]
  resources :votes, only: [:create, :destroy]
end
