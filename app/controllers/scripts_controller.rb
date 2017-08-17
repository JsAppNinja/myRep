class ScriptsController < ApplicationController
  skip_before_action :authenticate_shop
  skip_before_action :verify_authenticity_token

  def javascript
    @shop = Shop.find_by(shopify_domain: params[:shop])

    render inline: (render_to_string('embedded', formats: [:js, :erb])),
            content_type: 'application/javascript'
  end
end
