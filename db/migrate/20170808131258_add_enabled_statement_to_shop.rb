class AddEnabledStatementToShop < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :enabled, :boolean, default: false
  end
end
