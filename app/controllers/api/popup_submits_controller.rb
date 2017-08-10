class Api::PopupSubmitsController < ApplicationController
  skip_before_action :authenticate_shop, :verify_authenticity_token

  def create
    if session[:token] == service_params[:token]
      render json: {}, status: 404 unless load_and_check

      if @shop.popup_submits.create(popup_submit_params)
        render json: {}
      else
        render json: {}, status: 422
      end
    else
      render json: {}, status: 401
    end
  end


  private


  def load_and_check
    @shop = Shop.find_by(shopify_domain: service_params[:shop_name])
    @popup_activation = PopupActivation.find_by(session_token: popup_submit_params[:session_token])

    @shop.present? && @popup_activation.present?
  end

  def popup_submit_params
    params.require(:popup_submit).permit(:email, :name, :url, :session_token)
  end

  def service_params
    params.require(:popup_submit).permit(:token, :shop_name)
  end
end
