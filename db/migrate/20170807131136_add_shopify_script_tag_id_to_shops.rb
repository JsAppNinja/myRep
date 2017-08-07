class AddShopifyScriptTagIdToShops < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :shopify_script_tag_id, :string
  end
end
