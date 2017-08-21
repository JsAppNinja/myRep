class AddPlacementToPopupConfig < ActiveRecord::Migration[5.1]
  def change
    add_column :popup_configs, :placement, :integer, default: 0
  end
end
