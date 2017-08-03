class ShopSerializer < ActiveModel::Serializer
  has_one :popup_config

  attributes :shopify_domain
end
