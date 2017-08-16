require 'rails_helper'

RSpec.describe SlotItems::UpdateProduct do
  let(:shop)      { FactoryGirl.create(:shop) }
  let(:slot_item) { FactoryGirl.create(:slot_item, shop: shop, item_type: SlotItem::PRODUCT) }

  let(:handle)      { 'product' }
  let(:product_url) { "https://example/#{handle}" }

  before { allow(shop).to receive(:activate_session) }

  describe '.insert_product' do
    context 'with correct parameters' do
      let(:result) do
        SlotItems::UpdateProduct.insert_product(
          shop, slot_item, { product_url: product_url, image: 'image' }
        )
      end

      before do
        allow(ShopifyAPI::Product).to receive(:where).and_return(
          [OpenStruct.new({ id: '123' })]
        )
      end

      it 'should update title' do
        new_title = Faker::Name.title
        SlotItems::UpdateProduct.insert_product(
          shop, slot_item, { title: new_title, product_url: product_url, image: 'image' }
        )
        expect(slot_item.reload.title).to eq(new_title)
      end

      it 'should update product_url' do
        result
        expect(slot_item.reload.product_url).to eq(product_url)
      end

      it 'should update shopify_product_id' do
        result
        expect(slot_item.reload.shopify_product_id).to eq('123')
      end

      it 'should be success' do
        expect(result.success).to be_truthy
      end
    end

    context 'remote image' do
      let(:result) do
        SlotItems::UpdateProduct.insert_product(shop, slot_item, { product_url: product_url })
      end

      let(:image_url) do
        'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png'
      end

      before do
        allow(ShopifyAPI::Product).to receive(:where).and_return(
          [OpenStruct.new({ id: '123', images: 'images' })]
        )
        allow(ShopifyAPI::Product.where.first).to receive(:images).and_return(
          [OpenStruct.new({ src: image_url })]
        )
      end

      it 'should save url' do
        result
        expect(result.slot_item.remote_image_url).to eq(image_url)
      end
    end

    context 'with incorrect parameters' do
      context 'if product url blank' do
        let(:result) { SlotItems::UpdateProduct.insert_product(shop, slot_item, { product_url: '' }) }

        it 'should return error' do
          expect(result.errors).to eq("Product url can't be blank")
        end

        it 'should return success false' do
          expect(result.success).to be_falsy
        end

        it 'should not update product_url' do
          old_product_url = slot_item.product_url
          result
          expect(slot_item.reload.product_url).to eq(old_product_url)
        end
      end

      context 'if product in ShopifyAPI blank' do
        let(:result) do
          SlotItems::UpdateProduct.insert_product(shop, slot_item, { product_url: product_url })
        end

        it 'should return error' do
          allow(ShopifyAPI::Product).to receive(:where).and_return([])
          expect(result.errors).to eq("Can't find product with this url")
        end

        it 'should return success false' do
          allow(ShopifyAPI::Product).to receive(:where).and_return([])
          expect(result.success).to be_falsy
        end
      end
    end
  end
end
