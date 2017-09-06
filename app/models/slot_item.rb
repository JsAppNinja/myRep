class SlotItem < ActiveRecord::Base
  belongs_to :shop

  COUPON = 'coupon'
  PRODUCT = 'product'

  validates :title, presence: true, length: { maximum: 255 }
  validates :item_type, presence: true

  mount_uploader :image, SlotItemImageUploader

  validate :shopify_price_rule_id_presence_if_coupon?, :shopify_product_id_presence_if_product?,
           :coupon_presence_if_coupon?, :product_url_presence_if_product?

  def shopify_price_rule_id_presence_if_coupon?
    if item_type == COUPON && shopify_price_rule_id.blank?
      errors.add(:shopify_price_rule_id, "can't be blank")
      false
    else
      true
    end
  end

  def shopify_product_id_presence_if_product?
    if item_type == PRODUCT && shopify_product_id.blank?
      errors.add(:shopify_product_id, "can't be blank")
      false
    else
      true
    end
  end

  def coupon_presence_if_coupon?
    if item_type == COUPON && coupon.blank?
      errors.add(:coupon, "can't be blank")
      false
    else
      true
    end
  end

  def product_url_presence_if_product?
    if item_type == PRODUCT && product_url.blank?
      errors.add(:product_url, "can't be blank")
      false
    else
      true
    end
  end
end
