class ScriptTagService
  JS_SRC = "#{ENV['SCRIPTS_HOST']}/scripts/js".freeze

  def self.insert_script(shop)
    shop.activate_session
    script_tag = ShopifyAPI::ScriptTag.create(script_tag: { event: 'onload', src: JS_SRC })
    if script_tag.id.present?
      shop.update_columns(shopify_script_tag_id: script_tag.id)
    else
      Rollbar.error(StandardError.new(errors: script_tag.errors.full_messages))
    end
  end

  def self.remove_script(shop)
    shop.activate_session
    begin
      script_tag = ShopifyAPI::ScriptTag.find(shop.shopify_script_tag_id)
      if script_tag.present?
        ShopifyAPI::ScriptTag.delete(script_tag.id)
        shop.update_columns(shopify_script_tag_id: nil)
      end
    rescue ActiveResource::ResourceNotFound => ex
      Rails.logger.info ex
    end
  end


  def self.check_or_insert_tag(shop)
    shop.activate_session
    script_tag = ShopifyAPI::ScriptTag.all.find { |tg| tg.src == JS_SRC }
    if script_tag
      shop.update_columns(shopify_script_tag_id: script_tag.id)
    else
      insert_script(shop)
    end
  end
end
