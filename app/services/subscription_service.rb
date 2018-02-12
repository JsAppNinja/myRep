class SubscriptionService
  attr_reader :charge

  def initialize(shop)
    @shop = shop
  end

  def create(charge_id)
    @charge = ShopifyAPI::RecurringApplicationCharge.find(charge_id)

    if @charge.activate
      charge_attributes = @charge.attributes

      # change keys of some attributes to fit Subscription
      { plan_name: :name, charge_id: :id }
        .each { |k, v| charge_attributes[k] = charge_attributes.delete(v) }

      subscription_params = subscription_attributes(charge_attributes)

      if @shop.subscription
        @shop.subscription.update(subscription_params)
      else
        @shop.create_subscription(subscription_params)
      end
    else
      false
    end
  end

  private

  def subscription_attributes(charge_attributes)
    [
      :plan_name, :price,       :charge_id,    :api_client_id,
      :status,    :billing_on,  :activated_on,
    ].map { |attr| [attr, charge_attributes[attr]] }.to_h
  end
end