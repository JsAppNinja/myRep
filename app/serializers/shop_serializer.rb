class ShopSerializer < ActiveModel::Serializer
  attributes :shopify_domain, :id, :enabled, :analytics

  def analytics
    activations = object.popup_activations.count
    submits     = object.popup_submits.count

    {
      displayed:       activations,
      spinned:         submits,
      rejected:        activations - submits,
      conversion_rate: (submits * 100.0 / activations).round(2)
    }
  end
end
