class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action   :verify_authenticity_token
  before_action        :authenticate_shop


  private


  def authenticate_shop
    return if shop_signed_in?
    if params[:shop].present?
      redirect_to '/auth/shopify?shop=' + params[:shop]
    else
      redirect_to ENV['APP_STORE_URL'] || login_path
    end
  end

  def respond_with_errors(resource)
    render json: { errors: resource.errors.full_messages }, status: 422
  end

end
