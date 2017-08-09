require 'rails_helper'

RSpec.describe SlotItems::UpdateProduct do
  let(:shop) { FactoryGirl.create(:shop) }
  let(:slot_item) { FactoryGirl.create(:slot_item, ) }

  before { sign_in shop }

  context '.insert_product' do
    it 'should return error: No product url' do
      binding.pry
      # patch "/api/internal/v1/slot_items/#{slot_item.id}",
      #       params: { slot_item: { item_type: SlotItem::PRODUCT } }
    end
  end
end
