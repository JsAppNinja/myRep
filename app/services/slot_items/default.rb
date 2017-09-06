class SlotItems::Default
  def self.create_slot_items(shop)
    (1..SlotItem::DEFAULT_NUMBER).each do |n|
      shop.slot_items.create(
        title: "Coupon name #{n}",  item_type: 'coupon',
        shopify_price_rule_id: '1', coupon: '000-000-000'
      )
    end
  end
end
