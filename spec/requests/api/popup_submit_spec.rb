require 'rails_helper'

RSpec.describe Api::PopupSubmitsController, type: :request do
  let(:shop) { FactoryGirl.create(:shop) }

  describe 'POST /api/v1/popup_submits' do
    before do
      @popup_submit_params = FactoryGirl.attributes_for(
        :popup_submit, shop: shop
      )
      @popup_submit_params[:shop_name] = shop.shopify_domain
    end

    subject do
      post '/api/v1/popup_submits', params: { popup_submit: @popup_submit_params }
    end

    context 'with valid attributes' do
      it 'should respond with code 200' do
        expect(subject.to_i).to eq(200)
      end

      it 'should create new popup submit' do
        expect { subject }.to change { PopupSubmit.count }.by(1)
      end

      it 'should associate popup submit with shop' do
        subject
        expect(PopupSubmit.last.shop.shopify_domain).to eq(shop.shopify_domain)
      end
    end

    context 'with invalid attributes' do
      before { @popup_submit_params[:shop_name] = nil }

      it 'should not create new discount customer' do
        expect { subject }.not_to change { PopupSubmit }
      end

      it 'should respond with code 422' do
        expect(subject.to_i).to eq(422)
      end

      it 'should respond with error' do
        subject
        expect(json['errors']).to be
      end
    end
  end
end
