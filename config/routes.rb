Rails.application.routes.draw do
  devise_for :shops
  root to: 'static_pages#index'

  controller :sessions do
    get 'auth/shopify/callback' => :callback
  end

  controller :static_pages do
    get 'login' => :login
  end

  resource :settings, only: [:show, :update]
end
