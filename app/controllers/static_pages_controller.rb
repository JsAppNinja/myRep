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

  def frontend
    render 'frontend', layout: 'frontend'
  end
end
