# We handle all out events here
# Note: here must be only event and triggers, no implementation
class EventService
  class << self
    def new_shop_registered(shop)
      # TODO: process async
      ScriptTagService.insert_script(shop)
    end


    def new_sign_in(shop)
      ScriptTagService.check_or_insert_tag(shop)
    end

    def send_email(popup_submit)
      EmailService.send_letter(popup_submit)
    end

  end
end
