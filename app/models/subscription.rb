class Subscription < ApplicationRecord
  BASIC_PLAN = 'Basic'
  PRO_PLAN = 'Pro'

  STRIPE = 'Stripe'
  SHOPIFY = 'Shopify'

  belongs_to :shop
end
