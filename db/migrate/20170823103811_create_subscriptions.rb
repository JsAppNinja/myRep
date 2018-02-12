class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.string :plan_name
      t.string :price
      t.string :charge_id, null: false
      t.string :api_client_id, null: false
      t.string :status
      t.string :billing_on
      t.string :activated_on
      t.timestamps
    end
  end
end
