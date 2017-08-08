class Shop < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  include ShopifyApp::Shop
  include ShopifyApp::SessionStorage

  has_many :popup_activations
  has_many :popup_submits
  has_many :slot_items
  has_one :popup_config

  def activate_session
    session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(session)
  end
end
