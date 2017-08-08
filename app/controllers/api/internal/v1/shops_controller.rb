module Api
  module Internal
    module V1
      class ShopsController < ApplicationController
        skip_before_action :verify_authenticity_token

        def show
          render json: current_shop
        end

        def update
        end


        private


        def popup_config_params
          params.require(:shop).permit(:enabled)
        end
      end
    end
  end
end