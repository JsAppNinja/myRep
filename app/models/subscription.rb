class Subscription < ApplicationRecord
  PLANS = %w(basic pro)

  STRIPE  = 'stripe'
  SHOPIFY = 'shopify'

  belongs_to :shop
end
