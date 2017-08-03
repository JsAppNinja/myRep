class CreateDiscountedCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :discounted_customers do |t|
      t.integer :shop_id, index: true, foreign_key: true, null: false
      t.integer :email
      t.string :name

      t.timestamps null: false
    end
  end
end
