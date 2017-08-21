class RemoveUniqueIndexOnShopEmail < ActiveRecord::Migration[5.1]
  def up
    remove_index :shops, :email
    add_index    :shops, :email
  end
end
