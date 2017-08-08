module Api
  module Internal
    module V1
      class ShopsController < ApplicationController
        skip_before_action :verify_authenticity_token

        def show
          render json: current_shop
        end

        def update
          if current_shop.update(shop_params)
            render json: { enabled: current_shop.enabled }, status: 200
          else
            render json: current_shop.errors.messages, status: 401
          end
        end


        private


        def shop_params
          params.require(:shop).permit(:enabled)
        end
      end
    end
  end
end