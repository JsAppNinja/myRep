module Api
  module Internal
    module V1
      class SubscriptionsController < ApplicationController
        skip_before_action :verify_authenticity_token

        def create
          test_mode = ENV['TEST_SUBSCRIPTION'] || false
          plan      = subscriptions_params[:plan_name]

          if Subscription::PLANS.include?(plan)
            price = ENV["#{plan.upcase}_PLAN_PRICE"]
          else
            render json: { errors: ['Unknown plan'] } and return
          end

          charge = ShopifyAPI::RecurringApplicationCharge.new(
            name: subscriptions_params[:plan_name],
            price: price,
            return_url:"https://#{current_shop.shopify_domain}/admin/apps/#{ENV['SHOPIFY_CLIENT_API_KEY']}",
            test: test_mode
          )

          if charge.save
            render json: { confirmation_url: charge.confirmation_url }
          else
            render json: { errors: charge.errors.full_messages }, status: 422
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
