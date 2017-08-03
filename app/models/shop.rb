class Shop < ActiveRecord::Base
  SERVICE_SETTINGS = {
    triggers: {
      uri: {
        allowed_types: %w(Does Doesn't),
        allowed_matching_types: ['match', 'contain', 'begin with', 'end with']
      }
    }
  }


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  include ShopifyApp::Shop
  include ShopifyApp::SessionStorage


  def self.service_settings(key = nil, hash=SERVICE_SETTINGS)
    return SERVICE_SETTINGS if key == nil

    found = nil

    if hash.respond_to?(:key?) && hash.key?(key)
      return hash[key]
    elsif hash.is_a? Enumerable
      hash.find { |*a| found = service_settings(key, a.last) }
      return found
    end
  end

  def activate_session
    session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(session)
  end
end
