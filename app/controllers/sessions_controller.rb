class SessionsController < ApplicationController
  skip_before_action :authenticate_shop!

  def callback
    response = request.env['omniauth.auth']
    if response.present?
      shop_name = response.uid

      # create or sign in shop
      account = Shop.find_by(shopify_domain: shop_name) || Shop.new(shopify_domain: shop_name)

      # sign up
      if account.id.blank?
        account.shopify_token = response['credentials']['token']
        account.activate_session
        shop = ShopifyAPI::Shop.current

        account.email = shop.email
        account.password_confirmation = account.password = SecureRandom.hex(10)
        account.save
      end

      sign_in(account)
      sess = ShopifyAPI::Session.new(shop_name, response['credentials']['token'])
      session[:shopify] = ShopifyApp::SessionRepository.store(sess)
      session[:shopify_domain] = shop_name

      redirect_to "https://#{shop_name}/admin/apps/#{ENV['SHOPIFY_CLIENT_API_KEY']}"
    else
      flash[:error] = 'Could not log in to Shopify store.'
      redirect_to new_shop_session_path
    end
  end
end
