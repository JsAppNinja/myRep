class StaticPagesController < ApplicationController
  skip_before_action :authenticate_shop, only: :login

  def index
    render inline: "Hello #{current_shop.shopify_domain}!"
  end

  def login
    render :login, layout: 'static'
  end

end
