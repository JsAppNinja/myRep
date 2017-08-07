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
    end
  end

  namespace :api do
    namespace :internal do
      namespace :v1 do
        resource :popup_config, only: [:show, :update]
      end
    end
  end
end
