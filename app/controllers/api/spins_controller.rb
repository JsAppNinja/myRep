class Api::SpinsController < ApplicationController
  skip_before_action :authenticate_shop
  skip_before_action :verify_authenticity_token

  def create
    render json: {
      success: true,
      reels: 3.times.map { rand(1..7) },
      prize: { id: 2, payoutCredits: 0, payoutWinnings: 100 },
      credits: 9,
      dayWinnings: 100,
      lifetimeWinnings: 600
    }
  end

end