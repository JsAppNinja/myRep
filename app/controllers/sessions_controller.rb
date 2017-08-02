class SessionsController < ApplicationController
  skip_before_action :authenticate_shop

  def callback
    response = request.env['omniauth.auth']
    if response.blank?
      flash[:error] = 'Could not log in to Shopify store.'
      authenticate_shop
      return
    end

    shop_name = response.uid

    # create or sign in shop
    account = Shop.find_by(shopify_domain: shop_name) || Shop.new(shopify_domain: shop_name)

    # sign up
    if account.id.blank?
      account.shopify_token = response['credentials']['token']
      account.activate_session

      #allow(Shopify::Shop).to receive(:current).and_return(OpenStruct.new(email: 'alalal@le.com'))

      shop = ShopifyAPI::Shop.current
      account.email = shop.email

      password = SecureRandom.hex(10)
      account.password_confirmation = password
      account.password = password
      account.save!
    end

    sign_in(account)

    redirect_to "/"
  end
end
