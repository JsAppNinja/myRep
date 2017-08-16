class ShopSerializer < ActiveModel::Serializer
  attributes :shopify_domain, :id, :enabled, :analytics

  def analytics
    {
      displayed:       rand(50),
      spinned:         rand(50),
      rejected:        rand(20),
      conversion_rate: rand(100)
    }
  end
end
