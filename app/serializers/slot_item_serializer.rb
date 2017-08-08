class SlotItemSerializer < ActiveModel::Serializer
  belongs_to :shop

  attributes :id,                  :shop_id,                :title,  :item_type,
             :shopify_product_id,  :shopify_price_rule_id,  :coupon, :image_url,
             :product_url
end
