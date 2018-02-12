class StaticPagesController < ApplicationController
  skip_before_action :authenticate_shop, only: [:login, :slot_machine]

  def index
    check_for_new_subscription
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

  private

  def check_for_new_subscription
    if params[:charge_id].present?
      # actually SubscriptionService#create updates subscription too if it persisted
      SubscriptionService.new(current_shop).create(params[:charge_id])
    end
  end
end
