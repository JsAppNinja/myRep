class Api::PopupSubmitsController < ApplicationController
  skip_before_action :authenticate_shop, :verify_authenticity_token

  def create
    if session[:token] != service_params[:token]
      render json: {}, status: 455 and return
    end

    render json: {}, status: 404 unless load_and_check
    popup_submit = @shop.popup_submits.new(popup_submit_params)
    unless popup_submit.save
      render json: popup_submit.errors.full_messages, status: 422
      return
    end

    render json: {
      success: true,
      reels: 3.times.map { rand(1..7) },
      prize: { id: 2, payoutCredits: 0, payoutWinnings: 100 },
      credits: 9,
      dayWinnings: 100,
      lifetimeWinnings: 600
    }
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
