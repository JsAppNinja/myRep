require 'rails_helper'

RSpec.describe SlotItems::UpdateProduct do
  let(:shop)      { FactoryGirl.create(:shop) }
  let(:slot_item) { FactoryGirl.create(:slot_item, shop: shop, item_type: SlotItem::PRODUCT) }

  let(:handle)      { 'product' }
  let(:product_url) { "https://www.google.com/#{handle}" }

  before do
    allow(shop).to receive(:activate_session)
    allow(ShopifyAPI::Product).to receive(:all)
  end

  subject do
    SlotItems::UpdateProduct.insert_product(shop, slot_item, @slot_item_params)
  end

  describe '.insert_product' do
    context 'with correct parameters' do
      before do
        allow_message_expectations_on_nil
        allow(ShopifyAPI::Product.all).to receive(:where).and_return(
            [OpenStruct.new({ attributes: { id: '123' } })]
        )
      end

      it 'should update slot_item' do
        new_title = Faker::Name.title
        @slot_item_params = { product_url: product_url, title: new_title, image: 'image' }
        subject
        expect(slot_item.reload.title).to eq(new_title)
      end

      it 'should update shopify_product_id' do
        @slot_item_params = { product_url: product_url, image: 'image' }
        subject
        expect(slot_item.reload.shopify_product_id).to eq('123')
      end

      it 'should be success' do
        @slot_item_params = { product_url: product_url, image: 'image' }
        subject
        expect(subject.success).to be_truthy
      end
    end

    context 'with incorrect parameters' do
      it 'should return error: No product url' do
        @slot_item_params = { product_url: nil }
        expect(subject.errors).to eq('No product url')
      end

      it 'should return success false if no product url' do
        @slot_item_params = { product_url: nil }
        expect(subject.success).to be_falsy
      end

      it 'should return error: Cannot find product with this url' do
        @slot_item_params = { product_url: product_url }
        allow_message_expectations_on_nil
        allow(ShopifyAPI::Product.all).to receive(:where).and_return([])
        expect(subject.errors).to eq('Cannot find product with this url')
      end

      it 'should return success false if cannot find product with product_url' do
        @slot_item_params = { product_url: product_url }
        allow_message_expectations_on_nil
        allow(ShopifyAPI::Product.all).to receive(:where).and_return([])
        expect(subject.success).to be_falsy
      end

      it 'should not update product_url in slot_item' do
        old_product_url = slot_item.product_url
        @slot_item_params = { product_url: nil }
        subject
        expect(slot_item.reload.product_url).to eq(old_product_url)
      end
    end
  end
end
