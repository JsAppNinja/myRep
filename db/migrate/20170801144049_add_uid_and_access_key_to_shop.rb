class AddUidAndAccessKeyToShop < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :uid, :string
    add_column :shops, :access_key, :string
  end
end
