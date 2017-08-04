require 'rails_helper'

RSpec.describe Api::PopupActivationsController, type: :request do
  let(:shop) { FactoryGirl.create(:shop) }

  describe 'POST /api/v1/popup_activation' do
    before do
      @popup_activation_params = FactoryGirl.attributes_for(
        :popup_activation, shop: shop
      )
      @popup_activation_params[:shop_name] = shop.shopify_domain
    end

    subject do
      post '/api/v1/popup_activation', params: {
        popup_activation: @popup_activation_params
      }
    end

    context 'with valid attributes' do
      it 'should respond with code 200' do
        expect(subject.to_i).to eq(200)
      end

      it 'should create new popup activation' do
        expect { subject }.to change { PopupActivation.count }.by(1)
      end

      it 'should associate popup activation with shop' do
        subject
        expect(PopupActivation.last.shop.shopify_domain).to eq(shop.shopify_domain)
      end
    end

    context 'with invalid attributes' do
      before { @popup_activation_params[:shop_name] = nil }

      it 'should not create new popup activation' do
        expect { subject }.not_to change { PopupActivation }
      end

      it 'should respond with code 200' do
        expect(subject.to_i).to eq(200)
      end
    end
  end
end
