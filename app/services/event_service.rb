# We handle all out events here
# Note: here must be only event and triggers, no implementation
class EventService
  class << self
    def new_shop_registered(shop)
      # TODO: process async
      PopupConfigs::Default.create_popup_config(shop)
      SlotItems::Default.create_slot_items(shop)
      ScriptTagService.insert_script(shop)
    end


    def new_sign_in(shop)
      ScriptTagService.check_or_insert_tag(shop)
    end

    def popup_submit_created(popup_submit)
      EmailService.send_letter(popup_submit)
    end

  end
end
