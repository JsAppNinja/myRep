class PopupSubmitsController < ApplicationController
  skip_before_action :authenticate_shop

  def index
    render json: PopupSubmit.all.order('created_at DESC').page(params[:page])
  end

  def create
    shop_id = Shop.where(shopify_domain: params[:popup_submit][:shop_name]).pluck(:id).first
    head :ok and return if shop_id.nil?
    PopupSubmit.create!(popup_submit_params.merge(shop_id: shop_id))

    head :ok
  end

  def destroy
    popup_submit = PopupSubmit.find(params[:id])
    if popup_submit.destroy
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
