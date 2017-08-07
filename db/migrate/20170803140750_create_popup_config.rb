class CreatePopupConfig < ActiveRecord::Migration[5.1]
  def change
    create_table :popup_configs do |t|
      t.integer :shop_id,                  null:    false
      t.boolean :desktop_enabled,          default: false
      t.boolean :desktop_show_on_leave,    default: false
      t.boolean :desktop_show_on_timeout,  default: false
      t.integer :desktop_show_timeout,     default: 15

      t.boolean :tablet_enabled,           default: false
      t.boolean :tablet_show_on_leave,     default: false
      t.boolean :tablet_show_on_timeout,   default: false
      t.integer :tablet_show_timeout,      default: 15

      t.integer :show_days_timeout,        default: 30

      t.jsonb :uri_filters,                default: []
    end
  end
end
