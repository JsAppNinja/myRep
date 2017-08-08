ShopifyApp.configure do |config|
  config.api_key = ENV['SHOPIFY_CLIENT_API_KEY']
  config.secret = ENV['SHOPIFY_CLIENT_API_SECRET']
  config.scope = "read_orders, read_products, write_script_tags, read_price_rules, write_price_rules"
  config.embedded_app = false

  config.scripttags = [
    { event:'onload', src: 'https://localhost:3000/src/embedded.js' }
  ]
end
