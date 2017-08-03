class StaticPagesController < ApplicationController
  skip_before_action :authenticate_shop, only: :login

  def index
    render :index
  end

  def login
    render :login, layout: 'static'
  end

end
