module Api
  module Internal
    module V1
      class SubscriptionsController < ApplicationController
        skip_before_action :verify_authenticity_token

        def create
          current_shop.activate_session
          test_mode = ENV['TEST_SUBSCRIPTION'] || false

          if subscriptions_params[:plan_name] == Subscription::BASIC_PLAN
            price = ENV['BASIC_PLAN_PRICE']
          elsif subscriptions_params[:plan_name] == Subscription::PRO_PLAN
            price = ENV['PRO_PLAN_PRICE']
          end

          charge = ShopifyAPI::RecurringApplicationCharge.new(
            name: subscriptions_params[:plan_name],
            price: price,
            return_url:"https://#{current_shop.shopify_domain}/admin/apps/#{ENV['SHOPIFY_CLIENT_API_KEY']}",
            test: test_mode
          )

          if charge.save
            Subscription.create(
              plan_name: charge.name,            price: charge.price,
              charge_id: charge.id,              api_client_id: charge.api_client_id,
              status: charge.status,             billing_on: charge.billing_on,
              activated_on: charge.activated_on, shop_id: current_shop.id
            )
            redirect_to charge.confirmation_url
          else
            respond_with_errors(charge)
          end
        end


        private


        def subscriptions_params
          params.require(:subscription).permit(:plan_name)
        end
      end
    end
  end
end
