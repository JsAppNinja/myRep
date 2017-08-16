class SlotItems::UpdateCoupon
  def self.insert_coupon(shop, slot_item, slot_item_params)
    result = Struct.new(:success, :errors, :slot_item)

    if slot_item_params[:coupon].blank?
      return result.new(false, "Coupon can't be blank", slot_item)
    end

    if slot_item.update_attributes(slot_item_params)
      result.new(true, nil, slot_item)
    else
      result.new(false, slot_item.errors.full_messages, slot_item)
    end
  end
end
