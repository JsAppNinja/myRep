require 'rails_helper'

RSpec.describe PopupSubmitsController, type: :request do
  let(:shop)          { FactoryGirl.create(:shop) }
  let(:popup_submit)  { FactoryGirl.create(:popup_submit, shop: shop) }
  let(:per_page)      { PopupSubmit::PER_PAGE }

  describe 'GET /api/v1/popup_submits' do
    before do
      # devise sign_in
      sign_in shop
      @popup_submits = FactoryGirl.create_list(:popup_submit, 5, shop: shop)

      shop_2 = FactoryGirl.create(:shop)
      @popup_submits_2 = FactoryGirl.create_list(:popup_submit, 3, shop: shop_2)

      get '/api/v1/popup_submits'
    end

    it 'should respond with popup submits only for signed in shop' do
      returned_popup_submit_ids = json['popup_submits'].map{ |submit| submit['id'] }.sort
      popup_submit_ids = @popup_submits.map{ |submit| submit.id }.sort

      expect(returned_popup_submit_ids).to eq(popup_submit_ids)
    end

    it 'should not respond with popup submits for not signed in shop' do
      returned_popup_submit_ids = json['popup_submits'].map{ |submit| submit['id'] }.sort
      popup_submit_2_ids = @popup_submits_2.map{ |submit| submit.id }.sort

      expect(returned_popup_submit_ids).not_to include(
        popup_submit_2_ids[0],
        popup_submit_2_ids[1],
        popup_submit_2_ids[2]
      )
    end

    it 'should respond with code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/v1/popup_submits?page=1' do
    before do
      sign_in shop
      @popup_submits = FactoryGirl.create_list(
        :popup_submit, per_page + 5, shop: shop
      )
      get '/api/v1/popup_submits?page=1'
    end

    it 'should return popup submits for first page' do
      returned_submit_ids = json['popup_submits'].map{ |submit| submit['id'] }.sort
      page_1_submit_ids = @popup_submits[0..per_page - 1].map{ |submit| submit['id'] }.sort

      expect(returned_submit_ids).to eq(page_1_submit_ids)
    end

    it 'should not return popup submits for second page' do
      returned_submit_ids = json['popup_submits'].map{ |submit| submit['id'] }.sort
      page_2_submit_ids = @popup_submits[per_page..per_page + 5].map{ |submit| submit['id'] }.sort

      expect(returned_submit_ids).not_to include(
        page_2_submit_ids[0], page_2_submit_ids[1], page_2_submit_ids[2],
        page_2_submit_ids[3], page_2_submit_ids[4]
      )
    end
  end

  describe 'GET /api/v1/popup_submits?page=2' do
    before do
      sign_in shop
      @popup_submits = FactoryGirl.create_list(
        :popup_submit, per_page + 5, shop: shop
      )
      get '/api/v1/popup_submits?page=2'
    end

    it 'should return popup submits for second page' do
      returned_submit_ids = json['popup_submits'].map{ |submit| submit['id'] }.sort
      page_2_submit_ids = @popup_submits[per_page..per_page + 5].map{ |submit| submit['id'] }.sort
      expect(returned_submit_ids).to eq(page_2_submit_ids)
    end

    it 'should not return popup submits for first page' do
      returned_submit_ids = json['popup_submits'].map{ |submit| submit['id'] }.sort
      page_1_submit_ids = @popup_submits[0..per_page - 1].map{ |submit| submit['id'] }.sort

      expect(page_1_submit_ids).not_to include(
        returned_submit_ids[0], returned_submit_ids[1], returned_submit_ids[2],
        returned_submit_ids[3], returned_submit_ids[4]
      )
    end
  end

  describe 'DELETE /api/v1/popup_submits' do
    before do
      sign_in shop
    end

    context 'with popup_submit id in sign in shop' do
      subject do
        delete "/api/v1/popup_submits/#{popup_submit.id}"
      end

      it 'should respond with code 200' do
        expect(subject.to_i).to eq(200)
      end

      it 'should remove popup submit' do
        popup_submit
        expect { subject }.to change { PopupSubmit.count }.from(1).to(0)
      end
    end

    context 'with popup_submit id in not sign in shop' do
      let(:not_auth_shop_popup_submit) do
        FactoryGirl.create(
          :popup_submit,
          shop: FactoryGirl.create(:shop)
        )
      end

      subject do
        delete "/api/v1/popup_submits/#{not_auth_shop_popup_submit.id}"
      end

      it 'should respond with code 422' do
        expect(subject.to_i).to eq(422)
      end

      it 'should respond with error' do
        subject
        expect(json['errors']).to be
      end

      it 'should not remove popup submit' do
        popup_submit
        expect { subject }.not_to change { PopupSubmit }
      end
    end
  end
end
