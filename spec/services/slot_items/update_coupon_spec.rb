require 'rails_helper'

RSpec.describe SlotItems::UpdateCoupon do
  let(:shop)      { FactoryGirl.create(:shop) }
  let(:slot_item) { FactoryGirl.create(:slot_item, shop: shop, item_type: SlotItem::COUPON) }

  describe '.insert_coupon' do
    context 'with correct parameters' do
      let(:new_coupon) { '12345554321' }
      let(:result) { SlotItems::UpdateCoupon.insert_coupon(shop, slot_item, { coupon: new_coupon }) }

      it 'should update slot_item with coupon' do
        result
        expect(slot_item.reload.coupon).to eq(new_coupon)
      end

      it 'should return success true' do
        expect(result.success).to be_truthy
      end
    end

    context 'with incorrect parameters' do
      context 'if coupon is blank' do
        let(:result) { SlotItems::UpdateCoupon.insert_coupon(shop, slot_item, { coupon: '' }) }

        it 'should return error' do
          expect(result.errors).to eq(["Coupon can't be blank"])
        end

        it 'should return success false' do
          expect(result.success).to be_falsy
        end

        it 'should not update coupon' do
          old_coupon = slot_item.coupon
          result
          expect(slot_item.reload.coupon).to eq(old_coupon)
        end
      end
    end
  end
end
