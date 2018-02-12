require 'rails_helper'

RSpec.describe 'New shopify subscription', type: :request do
  describe 'create subscription' do
    let(:shop) { FactoryGirl.create(:shop) }

    before do
      sign_in shop
      env_for_omniauth
    end

    context "with plan name #{Subscription::BASIC_PLAN}" do
      let(:plan_name) { Subscription::BASIC_PLAN }
      let(:price)     { ENV['BASIC_PLAN_PRICE'] }

      context 'if instance of RecurringApplicationCharge saved' do
        let(:charge)  { new_charge(plan_name, price, true, nil) }

        before do
          allow(ShopifyAPI::RecurringApplicationCharge).to receive(:new).and_return(charge)
          post '/api/internal/v1/subscription',
                params: { subscription: { plan_name: plan_name } }
        end

        it 'should create new subscription' do
          expect(Subscription.count).to eq(1)
        end

        it "should create subscription with plan name #{Subscription::BASIC_PLAN}" do
          expect(shop.subscription.plan_name).to eq(Subscription::BASIC_PLAN)
        end

        it "should create subscription with price = #{ENV['BASIC_PLAN_PRICE']}" do
          expect(shop.subscription.price).to eq(ENV['BASIC_PLAN_PRICE'])
        end

        it 'should redirect to confirmation_url' do
          expect(response).to redirect_to(charge.confirmation_url)
        end
      end

      context "if instance of RecurringApplicationCharge don't saved" do
        let(:errors)  { OpenStruct.new(full_messages: ["It's error"]) }
        let(:charge)  { new_charge(plan_name, price, false, errors) }

        before do
          allow(ShopifyAPI::RecurringApplicationCharge).to receive(:new).and_return(charge)
          post '/api/internal/v1/subscription',
                params: { subscription: { plan_name: plan_name } }
        end

        it 'should not create new subscription' do
          expect(Subscription.count).to eq(0)
        end

        it 'should respond with error' do
          expect(json['errors']).to eq(errors.full_messages)
        end

        it 'should respond with code 422' do
          expect(response).to have_http_status(422)
        end
      end
    end

    context "with plan name #{Subscription::PRO_PLAN}" do
      let(:plan_name) { Subscription::PRO_PLAN }
      let(:price)     { ENV['PRO_PLAN_PRICE'] }

      context 'if instance of RecurringApplicationCharge saved' do
        let(:charge)  { new_charge(plan_name, price, true, nil) }

        before do
          allow(ShopifyAPI::RecurringApplicationCharge).to receive(:new).and_return(charge)
          post '/api/internal/v1/subscription',
                params: { subscription: { plan_name: plan_name } }
        end

        it 'should create new subscription' do
          expect(Subscription.count).to eq(1)
        end

        it "should create subscription with plan name #{Subscription::PRO_PLAN}" do
          expect(shop.subscription.plan_name).to eq(Subscription::PRO_PLAN)
        end

        it "should create subscription with price = #{ENV['PRO_PLAN_PRICE']}" do
          expect(shop.subscription.price).to eq(ENV['PRO_PLAN_PRICE'])
        end

        it 'should redirect to confirmation_url' do
          expect(response).to redirect_to(charge.confirmation_url)
        end
      end

      context "if instance of RecurringApplicationCharge don't saved" do
        let(:errors)  { OpenStruct.new(full_messages: ["It's error"]) }
        let(:charge)  { new_charge(plan_name, price, false, errors) }

        before do
          allow(ShopifyAPI::RecurringApplicationCharge).to receive(:new).and_return(charge)
          post '/api/internal/v1/subscription',
                params: { subscription: { plan_name: plan_name } }
        end

        it 'should not create new subscription' do
          expect(Subscription.count).to eq(0)
        end

        it 'should respond with error' do
          expect(json['errors']).to eq(errors.full_messages)
        end

        it 'should respond with code 422' do
          expect(response).to have_http_status(422)
        end
      end
    end
  end
end

def env_for_omniauth
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:shopify] = OmniAuth::AuthHash.new({
    'provider' => 'shopify',
    'uid' => 'my_app.myshopify.com',
    'info' => {},
    'credentials' => { 'token' => '0987654321', 'expires' => 'false' },
    'extra' => {
      'associated_user' => 'nil',
      'associated_user_scope' => 'nil',
      'scope' => 'write_products,write_orders'
    }
  })
end

def new_charge(plan_name, price, is_save, errors)
  OpenStruct.new(
    name: plan_name,
    price: price,
    return_url: 'https://example.com/admin/apps/a2b8b8a4c7f61c64be',
    test: true,
    id: 6100493,
    api_client_id: 1787505,
    status: 'pending',
    billing_on: nil,
    created_at: '2017-08-23T08:44:55-04:00',
    updated_at: '2017-08-23T08:44:55-04:00',
    activated_on: nil,
    trial_ends_on: nil,
    cancelled_on: nil,
    trial_days: 0,
    decorated_return_url: 'https://example.com/admin/apps/a2b8b8a4c7f61c64be?charge_id=6100493',
    confirmation_url: 'https://example.com/admin/charges/6100493/confirm_recurring_application_charg',
    save: is_save,
    errors: errors
  )
end
