Rails.application.routes.draw do
  devise_for :shops
  root to: 'static_pages#index'

  controller :sessions do
    get 'auth/shopify/callback' => :callback
  end

  controller :static_pages do
    get 'login' => :login
  end

  scope :api do
    scope 'v1' do
      resource :popup_activation, only: [:create]
      resources :popup_submits, only: [:create, :destroy, :index]
    end
  end
end
