# We handle all out events here
# Note: here must be only event and triggers, no implementation
class EventService
  class << self
    def new_shop_registered(shop)
      # TODO: process async
      ScriptTagService.insert_script(shop)
    end

  end
end