class RenameDiscountedCustomerToPopupSubmit < ActiveRecord::Migration[5.1]
  def change
    rename_table :discounted_customers, :popup_submits
  end
end
