class PopupActivationsController < ApplicationController
  skip_before_action :authenticate_shop

  def create
    shop_id = Shop.where(shopify_domain: params[:popup_activation][:shop_name]).pluck(:id).first
    head :ok and return if shop_id.nil?
    PopupActivation.create!(popup_activation_params.merge(shop_id: shop_id))

    head :ok
  end


  private


  def popup_activation_params
    params[:popup_activation].permit(:customer_id, :session_token, :ip, :url, :user_agent)
  end
end
