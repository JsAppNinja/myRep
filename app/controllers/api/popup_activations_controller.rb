class Api::PopupActivationsController < ApplicationController
  skip_before_action :authenticate_shop, :verify_authenticity_token

  def create
    if session[:token] != service_params[:token]
      render json: {}, status: 400 and return
    end

    shop = Shop.find_by(shopify_domain: service_params[:shop_name])
    if shop.present?
      popup_activation = shop.popup_activations.create(popup_activation_params)
      render json: { session_token: popup_activation.session_token }
    end
  end


  private


  def popup_activation_params
    params.require(:popup_activation).permit(:customer_id, :ip, :url, :user_agent)
  end

  def service_params
    params.require(:popup_activation).permit(:token, :shop_name)
  end
end
