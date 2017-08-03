class ShopSerializer < ActiveModel::Serializer
  attributes :shopify_domain, :enabled, :triggers

    def triggers
    triggers = triggers_fields.map { |field| [field, object[field.to_s]] }.to_h

    # service fields
    service_fields = {
      uri_filters: {
        allowed_types: Shop.service_settings(:allowed_types),
        allowed_matching_types: Shop.service_settings(:allowed_matching_types),
        uri_filters: object.uri_filters
      }
    }

    triggers.merge(service_fields)
  end


  private


  def triggers_fields
    [
      :desktop_enabled,   :desktop_show_on_leave, :desktop_show_on_timeout, :desktop_show_timeout,
      :tablet_enabled,    :tablet_show_on_leave,  :tablet_show_on_timeout,  :tablet_show_timeout,
      :show_days_timeout
    ]
  end
end
