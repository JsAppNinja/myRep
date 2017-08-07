class ScriptTagService

  def self.insert_script(shop)
    shop.activate_session
    script_tag = ShopifyAPI::ScriptTag.create(script_tag: { event: 'onload', src: "#{ENV['SCRIPTS_HOST']}/scripts/js" })
    if tag.id.present?
      shop.update_columns(shopify_script_tag_id: script_tag.id)
    else
      Rollbar.error(StandardError.new(errors: script_tag.errors.full_messages))
    end
  end
end
