require 'rails_helper'

RSpec.describe SlotItems::Default do
  let(:shop) { FactoryGirl.create(:shop) }

  subject { SlotItems::Default.create_slot_items(shop) }

  describe '.create_slot_items' do
    it 'should create SlotItem::DEFAULT_NUMBER slot items ' do
      subject
      expect(shop.slot_items.count).to eq(SlotItem::DEFAULT_NUMBER)
    end

    it 'should associate with shop' do
      subject
      expect(shop.slot_items.map{ |item| item.id }).to eq(SlotItem.all.map{ |item| item.id })
    end
  end

end
