class CreateSlotItem < ActiveRecord::Migration[5.1]
  def change
    create_table :slot_items do |t|
      t.integer :shop_id, index: true, foreign_key: true, null: false
      t.string :title
      t.string :item_type
      t.string :shopify_product_id
      t.string :shopify_price_rule_id
      t.string :coupon
      t.string :image
      t.string :product_url
    end
  end
end
