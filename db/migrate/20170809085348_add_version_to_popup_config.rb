class AddVersionToPopupConfig < ActiveRecord::Migration[5.1]
  def change
    add_column :popup_configs, :version, :integer, default: 0
  end
end
