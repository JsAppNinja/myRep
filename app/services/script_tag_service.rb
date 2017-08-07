class ScriptTagService

  def self.insert_script(shop)
    shop.activate_session
    script_tag = ShopifyAPI::ScriptTag.create(
      script_tag: { event: 'onload', src: "#{ENV['HOST']}/scripts/js" }
    )
    # remove script tag if we cannot save information about it
    if !shop.update_columns(shopify_script_tag_id: script_tag.id)
      script_tag.destroy
      # TODO: notify about this issue
    end
  end
end
