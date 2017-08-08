module Api
  module Internal
    module V1
      class SlotItemsController< ApplicationController

        def index
          slot_items = SlotItem.where(shop_id: current_shop.id)
          render json: slot_items, status: 200
        end

        def update
          @slot_item = current_shop.slot_items.find_by(id: params[:id])

          if @slot_item.nil?
            render json: { errors: 'You cannot update this' }, status: 422
            return
          end

          @slot_item.update(slot_item_params)
          if params[:slot_item][:product_url]
            success = update_slot_item_fields
            if success.nil?
              render json: { errors: 'Wrong product url' }, status: 422
              return
            end
          end

          render json: @slot_item, status: 200
        end


        private


        def slot_item_params
          params.require(:slot_item).permit(
            :title, :item_type, :coupon, :image, :product_url
          )
        end

        def update_slot_item_fields
          handle = params[:slot_item][:product_url].split('/').last
          current_shop.activate_session
          product = ShopifyAPI::Product.all.where("handle": handle)
          return nil if product.blank?

          if params[:slot_item][:image].nil?
            first_image_in_product = product.first.images.first.src
            @slot_item.remote_image_url = first_image_in_product
          end

          @slot_item.shopify_product_id = product.first.attributes[:id]
          @slot_item.save!
          true
        end

      end
    end
  end
end
