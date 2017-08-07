class CreatePopupActivations < ActiveRecord::Migration[5.1]
  def change
    create_table :popup_activations do |t|
      t.integer :shop_id, index: true, foreign_key: true, null: false
      t.integer :customer_id
      t.string :ip
      t.string :url
      t.string :user_agent
    end
  end
end
