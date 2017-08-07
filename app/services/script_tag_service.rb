class ScriptTagService
  JS_SRC = "#{ENV['SCRIPTS_HOST']}/scripts/js".freeze

  def self.insert_script(shop)
    shop.activate_session
    script_tag = ShopifyAPI::ScriptTag.create(script_tag: { event: 'onload', src: JS_SRC })
    if tag.id.present?
      shop.update_columns(shopify_script_tag_id: script_tag.id)
    else
      Rollbar.error(StandardError.new(errors: script_tag.errors.full_messages))
    end
  end


  def self.check_or_insert_tag(shop)
    shop.activate_session
    return if ShopifyAPI::ScriptTag.all.find { |tg| tg.src == JS_SRC }
    insert_script(shop)
  end
end
