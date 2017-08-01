class StaticPagesController < ApplicationController

  def index
    render inline: "Hello #{current_shop.shopify_domain}!"
  end

end
