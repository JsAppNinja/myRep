module Api
  module Internal
    module V1
      class PopupConfigsController < ApplicationController
        skip_before_action :verify_authenticity_token

        def show
          render json: current_shop.popup_config
        end

        def update_version
          pc = current_shop.popup_config
          pc.version += 1
          pc.save

          render json: {}
        end

        def update
          if current_shop.popup_config.update(popup_config_params)
            render json: {}
          else
            render json: current_shop.popup_config.errors.messages, status: 422
          end
        end


        private


        def popup_config_params
          params.require(:popup_config).permit(
            :desktop_enabled,   :desktop_show_on_leave, :desktop_show_on_timeout, :desktop_show_timeout,
            :tablet_enabled,    :tablet_show_on_leave,  :tablet_show_on_timeout,  :tablet_show_timeout,
            :show_days_timeout, uri_filters: [:type, :matching, :uri]
          )
        end
      end
    end
  end
end