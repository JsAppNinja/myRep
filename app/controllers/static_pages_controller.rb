class StaticPagesController < ApplicationController
  skip_before_action :authenticate_shop, only: [:login, :slot_machine]

  def index
    render :index, layout: 'application'
  end

  def login
    render :login, layout: 'static'
  end

  def slot_machine
    @token = SecureRandom.base64(100)
    session[:token] = @token

    render 'slot_machine', layout: 'frontend'
  end
end
