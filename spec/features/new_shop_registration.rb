require 'rails_helper'

RSpec.describe 'New shop registration', type: :request do
  context 'shop registered' do
    let(:script_tag_id) { "870402689" }

    subject do
      get '/auth/shopify/callback'
    end

    before do
      env_for_omniauth
      allow(ShopifyAPI::Shop).to receive(:current).and_return(
        OpenStruct.new(email: 'alalal@le.com')
      )
      allow(ShopifyAPI::ScriptTag).to receive(:create).and_return(
        OpenStruct.new(
            'id': script_tag_id,
            'src': 'https:\/\/djavaskripped.org\/fancy.js',
            'event': 'onload',
            'created_at': '2017-03-15T13:28:16-04:00',
            'updated_at': '2017-03-15T13:28:16-04:00',
            'display_scope': 'all'
        )
      )
    end

    it 'should create popup config' do
      expect { subject }.to change(PopupConfig, :count).by(1)
    end

    it 'should create slot items' do
      expect { subject }.to change(SlotItem, :count).by(6)
    end

    it 'should insert insert script' do
      subject
      expect(Shop.last.shopify_script_tag_id).to eq(script_tag_id)
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
