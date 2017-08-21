class ShopSerializer < ActiveModel::Serializer
  attributes :shopify_domain, :id, :enabled, :analytics

  def analytics
    activations      = object.popup_activations.count
    submits          = object.popup_submits.count
    converstion_rate = (submits * 100.0 / activations).round(2)

    {
      displayed:       activations,
      spinned:         submits,
      rejected:        activations - submits,
      conversion_rate: converstion_rate.nan? ? 0 : converstion_rate
    }
  end
end
