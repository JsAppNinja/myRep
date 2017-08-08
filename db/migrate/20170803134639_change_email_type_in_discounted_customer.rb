class ChangeEmailTypeInDiscountedCustomer < ActiveRecord::Migration[5.1]
  def change
    change_column :discounted_customers, :email, :string
  end
end
