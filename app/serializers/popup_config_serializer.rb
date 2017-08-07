class PopupConfigSerializer < ActiveModel::Serializer
  belongs_to :shop

  attributes :desktop_enabled,   :desktop_show_on_leave, :desktop_show_on_timeout, :desktop_show_timeout,
             :tablet_enabled,    :tablet_show_on_leave,  :tablet_show_on_timeout,  :tablet_show_timeout,
             :show_days_timeout, :uri_filters,           :service_fields

  def service_fields
    {
      uri_filters: {
        allowed_types: PopupConfig.service_settings(:allowed_types),
        allowed_matching_types: PopupConfig.service_settings(:allowed_matching_types)
      }
    }
  end
end