class Api::PopupSubmitsController < ApplicationController
  skip_before_action :authenticate_shop, :verify_authenticity_token

  def create
    if session[:token] == service_params[:token]
      shop = Shop.find_by(shopify_domain: service_params[:shop_name])
      if shop.present? && shop.popup_submits.create(popup_submit_params)
        head :ok
      end
    else
      render json: {}, status: 401
    end
  end


  private


  def popup_submit_params
    params.require(:popup_submit).permit(:email, :name, :url)
  end

  def service_params
    params.require(:popup_submit).permit(:token, :shop_name)
  end
end
