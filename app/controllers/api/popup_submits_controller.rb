class Api::PopupSubmitsController < ApplicationController
  skip_before_action :authenticate_shop
  skip_before_action :verify_authenticity_token

  def create
    shop_id = Shop.where(shopify_domain: params[:popup_submit][:shop_name]).pluck(:id).first

    popup_submit = PopupSubmit.new(popup_submit_params.merge(shop_id: shop_id))
    if popup_submit.save
      head :ok
    else
      respond_with_errors(popup_submit)
    end
  end


  private


  def popup_submit_params
    params[:popup_submit].permit(:email, :name, :url)
  end
end
