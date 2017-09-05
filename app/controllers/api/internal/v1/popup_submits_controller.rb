module Api
  module Internal
    module V1
      class PopupSubmitsController < ApplicationController

        def index
          popup_submits = PopupSubmit.where(shop_id: current_shop.id)
                                     .order(created_at: :desc)
                                     .page(params[:page] ||= 1)
                                     .per(params[:per_page] ||= 25)

          render json: popup_submits, meta: pagination_attributes(popup_submits)
        end


        def destroy
          popup_submit = current_shop.popup_submits.find_by(id: params[:id])

          if popup_submit.nil?
            render json: { errors: 'You cannot delete this' }, status: 422
            return
          end

          popup_submit.destroy
          head :ok
        end


        private


        def pagination_attributes(collection)
          {
            current_page: collection.current_page,
            next_page:    collection.last_page?,
            prev_page:    collection.first_page?,
            total_count:  collection.total_count,
            per_page:     params[:per_page]
          }
        end
      end
    end
  end
end

