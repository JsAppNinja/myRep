module Api
  module Internal
    module V1
      class PopupConfigsController< ApplicationController

        def show
          render json: current_shop
        end

        def update
          if current_shop.popup_config.update(popup_config_params)
            render json: {}, status: 200
          else
            render json: {}, status: 401
          end
        end


        private


        def popup_config_params
          params.require(:shop).require(:popup_config).permit(
            :desktop_enabled,   :desktop_show_on_leave, :desktop_show_on_timeout, :desktop_show_timeout,
            :tablet_enabled,    :tablet_show_on_leave,  :tablet_show_on_timeout,  :tablet_show_timeout,
            :show_days_timeout, uri_filters: [:type, :matching, :uri]
          )
        end
      end
    end
  end
end