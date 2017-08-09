# We handle all out events here
# Note: here must be only event and triggers, no implementation
class EventService
  class << self
    def new_shop_registered(shop)
      # TODO: process async
      ScriptTagService.insert_script(shop)
    end


    def new_sign_in(shop)
      ScriptTagService.check_or_insert_tag(shop)
    end

    def update_product(current_shop, slot_item, slot_item_params)
      SlotItems::UpdateProduct.insert_product(current_shop, slot_item, slot_item_params)
    end

  end
end
