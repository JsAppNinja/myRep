class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action        :authenticate_shop


  private


  def authenticate_shop
    if params[:shop].present?
      shop = Shop.find_by(shopify_domain: params[:shop])

      shop.present? ? sign_in(shop) : redirect_to('/auth/shopify?shop=' + params[:shop])
    else
      shop_signed_in? ? return : redirect_to(ENV['APP_STORE_URL'] || login_path)
    end
  end

  def respond_with_errors(resource)
    render json: { errors: resource.errors.full_messages }, status: 422
  end

end
