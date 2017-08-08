class SlotItem < ActiveRecord::Base
  belongs_to :shop

  validates :title, presence: true, length: { maximum: 255 }
  validates :item_type, :shopify_product_id, :shopify_price_rule_id, presence: true

  mount_uploader :image, SlotItemImageUploader
end
