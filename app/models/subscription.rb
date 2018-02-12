class Subscription < ApplicationRecord
  BASIC_PLAN = 'basic'
  PRO_PLAN   = 'pro'

  STRIPE  = 'stripe'
  SHOPIFY = 'shopify'

  belongs_to :shop
end
