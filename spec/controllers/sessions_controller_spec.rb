require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  subject { get :callback }

  before do
    env_for_omniauth
    allow(ShopifyAPI::Shop).to receive(:current).and_return(
      OpenStruct.new(email: 'alalal@le.com')
    )
    allow(ShopifyAPI::ScriptTag).to receive(:create).and_return(
      OpenStruct.new(
          'id': 870402689,
          'src': 'https:\/\/djavaskripped.org\/fancy.js',
          'event': 'onload',
          'created_at': '2017-03-15T13:28:16-04:00',
          'updated_at': '2017-03-15T13:28:16-04:00',
          'display_scope': 'all'
      )
    )
    allow(ShopifyAPI::ScriptTag).to receive(:all).and_return(
      OpenStruct.new('src': 'https:\/\/djavaskripped.org\/fancy.js')
    )
  end

  describe 'oauth parameters blank' do
    it 'should redirect to root path' do
      expect(subject).to redirect_to(root_path)
    end
  end

  describe 'oauth parameters present and it is new shop' do
    it 'should create new shop' do
      expect { subject }.to change(Shop, :count).by(1)
    end

    it 'should save shop access token' do
      subject
      expect(
        Shop.last.shopify_token
      ).to eq(request.env['omniauth.auth']['credentials']['token'])
    end

    it 'should activate session' do
      expect_any_instance_of(Shop).to receive(:activate_session).twice
      subject
    end

    it 'should perform api call via Shopify::Shop.current' do
      expect(ShopifyAPI::Shop).to receive(:current)
      subject
    end

    it 'should assign shop email' do
      subject
      expect(Shop.last.email).to eq(ShopifyAPI::Shop.current.email)
    end

    it 'should perform sign in' do
      expect_any_instance_of(SessionsController).to receive(:sign_in)
      subject
    end

    it 'should redirect to root path' do
      expect(subject).to redirect_to(root_path)
    end
  end

  describe 'oauth parameters present and it is installed shop' do
    let(:shop) { FactoryGirl.create(:shop) }

    before do
      request.env['omniauth.auth']['uid'] = shop.shopify_domain
      request.env['omniauth.auth']['credentials']['token'] = shop.shopify_token
    end

    it 'should not create new shop' do
      expect { subject }.not_to change { Shop }
    end

    it 'should not write down shopify token' do
      subject
      expect_any_instance_of(Shop).not_to receive(:shopify_token)
    end

    it 'should activate session' do
      expect_any_instance_of(Shop).to receive(:activate_session).thrice
      subject
    end

    it 'should perform api call via Shopify::Shop.current' do
      expect(ShopifyAPI::Shop).to receive(:current)
      subject
    end

    it 'should not write down email' do
      subject
      expect_any_instance_of(Shop).not_to receive(:email)
    end

    it 'should perform sign in' do
      expect_any_instance_of(SessionsController).to receive(:sign_in)
      subject
    end

    it 'should redirect to root path' do
      expect(subject).to redirect_to(root_path)
    end
  end
end

def env_for_omniauth
  OmniAuth.config.test_mode = true
  request.env["devise.mapping"] = Devise.mappings[:user]
  request.env["omniauth.auth"] = OmniAuth::AuthHash.new({
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
