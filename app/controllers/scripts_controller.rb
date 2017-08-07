class ScriptsController < ApplicationController
  skip_before_action :authenticate_shop
  skip_before_action :verify_authenticity_token

  def javascript
    render inline: (render_to_string('embedded', formats: [:js, :erb])),
            content_type: 'application/javascript'
  end

  def stylesheet
    render 'embedded', formats: [:css], content_type: 'text/css; charset=utf-8'
  end
end