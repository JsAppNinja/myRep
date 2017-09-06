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


        def save_as_csv
          popup_submits = PopupSubmit.where(shop_id: current_shop.id).order(email: :asc)
          filename = "collected-emails-#{Time.now.utc.strftime('%Y%m%d%H%M%S')}.csv"

          # front-end saves file with the name set in headers
          # but just in case lets specify it in send_data() too
          response.headers["FILENAME"] = filename
          send_data popup_submits.to_csv, filename: filename
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

