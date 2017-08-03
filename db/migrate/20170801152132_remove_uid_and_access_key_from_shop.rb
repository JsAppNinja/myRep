class RemoveUidAndAccessKeyFromShop < ActiveRecord::Migration[5.1]
  def change
    remove_column :shops, :uid, :string
    remove_column :shops, :access_key, :string
  end
end
