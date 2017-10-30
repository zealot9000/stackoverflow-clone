Rails.application.routes.draw do

  use_doorkeeper
root to: "questions#index"
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :questions do
    resources :answers, shallow: true do
      member do
        patch :mark_best
      end
    end
  end

  resources :attachments, only: [:destroy]
  resources :votes, only: [:create, :destroy]
  resources :comments, only: [:create]

  mount ActionCable.server => '/cable'

  match "/register_email" => "omnitokens#register_email", :via => :post
  match "/verify_email" => "omnitokens#verify_email", :via => :get

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :index
      end
    end
  end
end
