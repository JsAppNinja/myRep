require 'rails_helper'

RSpec.describe PopupSubmitsController, type: :request do
  let(:shop)          { FactoryGirl.create(:shop) }
  let(:popup_submit)  { FactoryGirl.create(:popup_submit, shop: shop) }

  describe 'GET /api/v1/popup_submits' do
    before do
      @all_popup_submits = FactoryGirl.create_list(:popup_submit, 5, shop: shop)
      get '/api/v1/popup_submits'
    end

    it 'should respond with code 200' do
      expect(response).to have_http_status(200)
    end

    it 'should respond with popup submits' do
      expect(
        JSON.parse(response.body).map{ |submit| submit['id'] }.sort
      ).to eq(@all_popup_submits.map{ |submit| submit['id'] }.sort)
    end
  end

  describe 'POST /api/v1/popup_submits' do
    before {
      @popup_submit_params = FactoryGirl.attributes_for(
        :popup_submit,
        shop: shop
      )
      @popup_submit_params[:shop_name] = shop.shopify_domain
    }

    subject do
      post '/api/v1/popup_submits', params: {
        popup_submit: @popup_submit_params
      }
    end

    context 'with valid attributes' do
      it 'should respond with code 200' do
        expect(subject.to_i).to eq(200)
      end

      it 'should create new popup submit' do
        expect { subject }.to change(PopupSubmit, :count).by(1)
      end

      it 'should associate popup submit with shop' do
        subject
        expect(
          PopupSubmit.last.shop.shopify_domain
        ).to eq(shop.shopify_domain)
      end
    end

    context 'with invalid attributes' do
      before { @popup_submit_params[:shop_name] = nil }

      it 'should not create new discount customer' do
        expect { subject }.not_to change { PopupSubmit }
      end

      it 'should respond with code 200' do
        expect(subject.to_i).to eq(200)
      end
    end
  end

  describe 'DELETE /api/v1/popup_submits' do
    subject do
      delete "/api/v1/popup_submits/#{popup_submit.id}"
    end

    it 'should respond with code 200' do
        expect(subject.to_i).to eq(200)
    end

    it 'should remove popup_submit' do
      popup_submit
      expect{ subject }.not_to change { PopupSubmit }
    end
  end
end
