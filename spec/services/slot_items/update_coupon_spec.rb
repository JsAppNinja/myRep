require 'rails_helper'

RSpec.describe SlotItems::UpdateCoupon do
  let(:shop)      { FactoryGirl.create(:shop) }
  let(:slot_item) { FactoryGirl.create(:slot_item, shop: shop, item_type: SlotItem::COUPON) }

  subject do
    SlotItems::UpdateCoupon.insert_coupon(shop, slot_item, @slot_item_params)
  end

  describe '.insert_coupon' do
    let(:new_coupon) { '12345554321' }

    context 'with correct parameters' do
      it 'should update slot_item with coupon' do
        @slot_item_params = { coupon: new_coupon }
        subject
        expect(slot_item.reload.coupon).to eq(new_coupon)
      end

      it 'should return success true' do
        @slot_item_params = { coupon: new_coupon }
        expect(subject.success).to be_truthy
      end
    end

    context 'with incorrect parameters' do
      it 'should return error: Coupon is blank' do
        @slot_item_params = { coupon: nil }
        expect(subject.errors).to eq('Coupon is blank')
      end

      it 'should return success false if coupon is blank' do
        @slot_item_params = { coupon: nil }
        expect(subject.success).to be_falsy
      end
    end
  end
end
