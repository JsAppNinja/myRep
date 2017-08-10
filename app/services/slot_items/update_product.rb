class SlotItems::UpdateProduct
  def self.insert_product(shop, slot_item, slot_item_params)
    result = OpenStruct.new

    if slot_item_params[:product_url].nil?
      result.success = false
      result.errors = 'No product url'
      return result
    end

    handle = slot_item_params[:product_url].split('/').last
    shop.activate_session

    product = ShopifyAPI::Product.all.where("handle": handle)
    if product.blank?
      result.success = false
      result.errors = 'Cannot find product with this url'
      return result
    end

    slot_item.update(slot_item_params)

    if slot_item_params[:image].nil?
      first_image_in_product = product.first.images.first.src
      slot_item.remote_image_url = first_image_in_product
    end

    slot_item.shopify_product_id = product.first.attributes[:id]
    slot_item.save!

    result.success = true
    result
  end

end
