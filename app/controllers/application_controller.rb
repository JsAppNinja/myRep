class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_shop!


  private


  def authenticate_shop!
    unless shop_signed_in?
      redirect_to '/auth/shopify?shop=' + params[:shop]
    end
  end

end
