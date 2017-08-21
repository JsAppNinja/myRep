class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action        :authenticate_shop


  private


  def authenticate_shop
    if current_shop.blank?
      redirect_to shop_login_path
    elsif params[:shop].class == String &&
         current_shop.shopify_domain != params[:shop]
      sign_out(current_shop)
      redirect_to shop_login_path
    end
  end

  def shop_login_path
    if params[:shop].present?
      '/auth/shopify?shop=' + params[:shop]
    else
      ENV['APP_STORE_URL'] || login_path
    end
  end

  def respond_with_errors(resource)
    render json: { errors: resource.errors.full_messages }, status: 422
  end
end
