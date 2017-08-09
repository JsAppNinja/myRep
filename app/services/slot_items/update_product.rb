class SlotItems::UpdateProduct
  def self.insert_product(current_shop, slot_item, slot_item_params)
    result = OpenStruct.new

    if slot_item_params[:product_url].nil?
      result.errors = 'No product url'
      return result
    end

    slot_item.update(slot_item_params)

    handle = slot_item_params[:product_url].split('/').last
    current_shop.activate_session
    product = ShopifyAPI::Product.all.where("handle": handle)

    if product.blank?
      result.errors = 'Wrong product url'
      return result
    end

    if slot_item_params[:image].nil?
      first_image_in_product = product.first.images.first.src
      slot_item.remote_image_url = first_image_in_product
    end

    slot_item.shopify_product_id = product.first.attributes[:id]
    slot_item.save!
  end

end
