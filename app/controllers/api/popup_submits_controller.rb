class Api::PopupSubmitsController < ApplicationController
  skip_before_action :authenticate_shop
  skip_before_action :verify_authenticity_token

  def create
    shop = Shop.find_by(shopify_domain: params[:popup_submit][:shop_name])
    if shop.present? && shop.popup_submits.create(popup_submit_params)
      head :ok
    else
      render json: {}, status: 500
    end
  end


  private


  def popup_submit_params
    params.require(:popup_submit).permit(:email, :name, :url)
  end
end
