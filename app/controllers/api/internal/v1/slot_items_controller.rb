module Api
  module Internal
    module V1
      class SlotItemsController< ApplicationController

        def index
          slot_items = SlotItem.where(shop_id: current_shop.id)
          render json: slot_items
        end

        def update
          slot_item = current_shop.slot_items.find(params[:id])

          if slot_item_params[:item_type] == SlotItem::PRODUCT
            result = SlotItems::UpdateProduct.insert_product(current_shop, slot_item, slot_item_params)
          else slot_item_params[:item_type] == SlotItem::COUPON
            result = SlotItems::UpdateCoupon.insert_coupon(current_shop, slot_item, slot_item_params)
          end

          if result.success
            render json: slot_item
          else
            render json: { errors: result.errors }, status: 422
          end
        end


        private


        def slot_item_params
          params.require(:slot_item).permit(
            :title, :item_type, :coupon, :image, :product_url
          )
        end

      end
    end
  end
end
