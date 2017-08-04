class Api::PopupActivationsController < ApplicationController
  skip_before_action :authenticate_shop

  def create
    popup_activation = PopupActivation.new(popup_activation_params)
    shop = Shop.find_by(shopify_domain: params[:popup_activation][:shop_name])
    if shop.present?
      popup_activation.shop_id = shop.id
      popup_activation.save
    end
    head :ok
  end


  private


  def popup_activation_params
    params[:popup_activation].permit(:customer_id, :ip, :url, :user_agent)
  end
end
