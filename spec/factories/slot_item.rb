FactoryGirl.define do
  factory :slot_item do
    shop
    title                 { Faker::Name.title }
    item_type             { ['coupon', 'product'].sample }
    shopify_product_id    { SecureRandom.random_number(100_000_000) }
    shopify_price_rule_id { SecureRandom.random_number(100_000_000) }
    coupon                { SecureRandom.random_number(100_000_000) }
    image                 { Faker::Avatar.image }
    product_url           { Faker::Internet.url('my-app.myshopify.com') }
  end
end
