require 'rails_helper'

RSpec.describe Api::Internal::V1::PopupConfigsController, type: :request do
  let(:shop) { FactoryGirl.create(:shop) }

  describe 'GET /api/internal/v1/slot_items' do
    before do
      # devise sign_in
      sign_in shop
      @slot_items = FactoryGirl.create_list(:slot_item, 7, shop: shop)

      shop_2 = FactoryGirl.create(:shop)
      @slot_items_2 = FactoryGirl.create_list(:slot_item, 3, shop: shop_2)

      get '/api/internal/v1/slot_items'
    end

    it 'should respond with slot items only for signed in shop' do
      returned_slot_item_ids = json['slot_items'].map{ |item| item['id'] }.sort
      slot_item_ids = @slot_items.map{ |item| item.id }.sort

      expect(returned_slot_item_ids).to eq(slot_item_ids)
    end

    it 'should not respond with slot items for not signed in shop' do
      returned_slot_item_ids = json['slot_items'].map{ |item| item['id'] }.sort
      slot_item_2_ids = @slot_items_2.map{ |item| item.id }.sort

      expect(returned_slot_item_ids).not_to include(
        slot_item_2_ids[0], slot_item_2_ids[1], slot_item_2_ids[2]
      )
    end

    it 'should respond with code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'PATCH /api/internal/v1/slot_items/:id' do
    let(:slot_item) { FactoryGirl.create(:slot_item, shop: shop) }

    before { sign_in shop }

    context 'with valid params' do
      let(:new_coupon) { '12345' }

      subject do
        patch "/api/internal/v1/slot_items/#{slot_item.id}",
              params: { slot_item: { coupon: new_coupon, item_type: 'coupon' } }
      end

      it 'should respond with code 200' do
        expect(subject).to eq(200)
      end

      it 'should update slot_item' do
        subject
        expect(slot_item.reload.coupon).to eq(new_coupon)
      end

      it 'should respond with slot_item' do
        subject
        expect(json['slot_item']['id'].to_i).to eq(slot_item.id)
      end
    end

    context 'with wrong params' do
      subject do
        patch "/api/internal/v1/slot_items/#{slot_item.id}",
              params: { slot_item: @slot_item_params }
      end

      it 'should respond with error: Item type do not selected' do
        @slot_item_params = { item_type: nil }
        subject
        expect(json['errors']).to eq('Item type do not selected')
      end

      it 'should respond with code 422 if item type do not selected' do
        @slot_item_params = { item_type: nil }
        expect(subject).to eq(422)
      end

      it 'should respond with error: Coupon is blank' do
        @slot_item_params = { item_type: 'coupon' }
        subject
        expect(json['errors']).to eq('Coupon is blank')
      end

      it 'should respond with code 422 if coupon is blank' do
        @slot_item_params = { item_type: 'coupon' }
        expect(subject).to eq(422)
      end
    end

    context 'with wrong id' do
      subject do
        patch "/api/internal/v1/slot_items/#{slot_item.id + 10}",
              params: { slot_item: { title: Faker::Name.title} }
      end

      it 'should raise error RecordNotFound' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'should not update slot_item' do
        old_title = slot_item.title
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        expect(slot_item.reload.title).to eq(old_title)
      end

    end
  end
end
