class AddTimestampsToPopupActivation < ActiveRecord::Migration[5.1]
  def change
    change_table :popup_activations do |t|
      t.timestamps null: false
    end
  end
end
