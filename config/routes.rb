Rails.application.routes.draw do
  devise_for :shops
  root to: 'static_pages#index'
  get 'frontend', to: 'static_pages#frontend'

  controller :sessions do
    get 'auth/shopify/callback' => :callback
  end

  controller :static_pages do
    get 'login', to: :login
  end
end
