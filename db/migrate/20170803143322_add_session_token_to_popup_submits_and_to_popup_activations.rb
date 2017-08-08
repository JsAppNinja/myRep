class AddSessionTokenToPopupSubmitsAndToPopupActivations < ActiveRecord::Migration[5.1]
  def change
    add_column :popup_submits, :session_token, :string
    add_column :popup_activations, :session_token, :string
    add_index :popup_submits, :session_token
    add_index :popup_activations, :session_token
  end
end
