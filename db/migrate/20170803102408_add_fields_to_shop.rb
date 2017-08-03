class AddFieldsToShop < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :enabled,                   :boolean, default: false

    add_column :shops, :desktop_enabled,           :boolean, default: false
    add_column :shops, :desktop_show_on_leave,     :boolean, default: false
    add_column :shops, :desktop_show_on_timeout,   :boolean, default: false
    add_column :shops, :desktop_show_timeout,      :integer, default: 15

    add_column :shops, :tablet_enabled,            :boolean, default: false
    add_column :shops, :tablet_show_on_leave,      :boolean, default: false
    add_column :shops, :tablet_show_on_timeout,    :boolean, default: false
    add_column :shops, :tablet_show_timeout,       :integer, default: 15

    add_column :shops, :show_days_timeout,         :integer, default: 30

    add_column :shops, :uri_filters,               :jsonb,   default: []
  end
end
