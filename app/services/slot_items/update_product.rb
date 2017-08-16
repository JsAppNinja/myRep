class SlotItems::UpdateProduct
  def self.insert_product(shop, slot_item, slot_item_params)
    result = Struct.new(:success, :errors, :slot_item)

    if slot_item_params[:product_url].blank?
      return result.new(false, "Product url can't be blank", slot_item)
    end

    shop.activate_session
    handle = slot_item_params[:product_url].split('/').last
    product = ShopifyAPI::Product.where(handle: handle).first
    if product.nil?
      return result.new(false, "Can't find product with this url", slot_item)
    end

    if (slot_item_params[:image].blank? && product.images.present? &&
        product.images.first.present?   && product.images.first.src.present?)
      slot_item.remote_image_url = product.images.first.src
    end

    slot_item.shopify_product_id = product.id

    if slot_item.update_attributes(slot_item_params)
      result.new(true, nil, slot_item)
    else
      result.new(false, slot_item.errors.full_messages, slot_item)
    end
  end

end
