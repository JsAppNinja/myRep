require 'rails_helper'

RSpec.describe Api::Internal::V1::PopupConfigsController, type: :controller do
  describe 'show page' do
    let(:shop) { FactoryGirl.create(:shop) }
    let(:popup_config) { FactoryGirl.create(:popup_config, shop_id: shop.id) }

    before do
      sign_in shop
      popup_config
    end

    subject { get :show }

    it 'should return shop' do
      expect(subject.body).to have_content(shop.shopify_domain)
    end

    it 'should return popup config' do
      expect(subject.body).to have_content(
        popup_config.show_days_timeout.to_json
      )
    end
  end

  describe 'update' do
    let(:shop) { FactoryGirl.create(:shop) }
    let(:popup_config) { FactoryGirl.create(:popup_config, shop_id: shop.id) }
    let(:uri_filter_sample) do
      {
        type:          PopupConfig.service_settings(:allowed_types).sample,
        matching_type: PopupConfig.service_settings(:allowed_matching_types).sample,
        uri:           Faker::Internet.url
      }
    end

    before do
      sign_in shop
    end

    subject do
      popup_config_changed = popup_config.attributes
      popup_config_changed['desktop_enabled '] = !popup_config_changed['desktop_enabled']
      popup_config_changed['uri_filters'] << uri_filter_sample
      post :update, params: { shop: { popup_config: popup_config_changed } }
    end

    it 'should return 200 OK' do
      expect(subject.status).to eq(200)
    end

    it 'should update PopupConfig instance' do
      subject
      expect(popup_config.uri_filters).to eq([uri_filter_sample])
    end
  end
end
