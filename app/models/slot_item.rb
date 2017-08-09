class SlotItem < ActiveRecord::Base
  belongs_to :shop

  COUPON = 'coupon'
  PRODUCT = 'product'

  validates :title, presence: true, length: { maximum: 255 }
  validates :item_type, presence: true

  mount_uploader :image, SlotItemImageUploader

  validate :shopify_price_rule_id_if_coupon, :shopify_product_id_if_product

  def shopify_price_rule_id_if_coupon
    if item_type == COUPON && shopify_price_rule_id.blank?
      errors.add(:shopify_price_rule_id, "can't be blank")
    end
  end

  def shopify_product_id_if_product
    if item_type == PRODUCT && shopify_product_id.blank?
      errors.add(:shopify_product_id, "can't be blank")
    end
  end
end
