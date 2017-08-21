class Shop < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  include ShopifyApp::Shop
  include ShopifyApp::SessionStorage

  has_many :popup_activations
  has_many :popup_submits
  has_many :slot_items
  has_one :popup_config
  has_one  :popup_config

  after_save :remove_or_add_scripts, if: :enabled_changed?

  def activate_session
    session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(session)
  end

  def remove_or_add_scripts
    if enabled
      ScriptTagService.insert_script(self)
    else
      ScriptTagService.remove_script(self)
    end
  end
end
