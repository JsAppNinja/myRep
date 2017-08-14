class StaticPagesController < ApplicationController
  skip_before_action :authenticate_shop, only: :login

  def index
    render :index, layout: 'application'
  end

  def login
    render :login, layout: 'static'
  end

  def index
  end

  # TODO: if slot machine will work with vue delete this lines with frontend.html.erb
  # def frontend
  #   @token = SecureRandom.base64(100)
  #   session[:token] = @token
  #
  #   render 'frontend', layout: 'frontend'
  # end

  def slot_machine
    @token = SecureRandom.base64(100)
    session[:token] = @token

    render 'slot_machine', layout: 'frontend'
  end
end
