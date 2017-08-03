class AddUrlToDiscountedCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :discounted_customers, :url, :string
  end
end
