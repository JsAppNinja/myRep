class SlotItems::UpdateCoupon
  def self.insert_coupon(shop, slot_item, slot_item_params)
    result = OpenStruct.new

    if slot_item_params[:coupon].nil?
      result.success = false
      result.errors = 'Coupon is blank'
      return result
    end

    slot_item.update(slot_item_params)
    slot_item.save!

    result.success = true
    result
  end
end
