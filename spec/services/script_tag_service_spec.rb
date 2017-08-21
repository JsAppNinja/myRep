require 'rails_helper'

RSpec.describe ScriptTagService do
  let(:shop) { double(:shop) }

  context ".insert_script" do
    it 'should JS_SRC be correct' do
      js_src = "#{ENV['SCRIPTS_HOST']}/scripts/js".freeze
      expect(ScriptTagService::JS_SRC).to eq(js_src)
    end

    it "should update the shop" do
      allow(shop).to receive(:activate_session)
      allow(ShopifyAPI::ScriptTag).to receive(:create).and_return(OpenStruct.new('id': 123))
      expect(shop).to receive(:update_columns).with(shopify_script_tag_id: 123)
      ScriptTagService.insert_script(shop)
    end
  end

  context '.check_or_insert_tag' do
    it 'should find JS_SRC' do
      allow(shop).to receive(:activate_session)
      allow(ShopifyAPI::ScriptTag).to receive(:all).and_return(
        [OpenStruct.new('id': 1, 'src': 'https:\/\/djavaskripped.org\/fancy.js'),
         OpenStruct.new('id': 2, 'src': ScriptTagService::JS_SRC)]
      )
      expect(shop).to receive(:update_columns).with(shopify_script_tag_id: 2)
      ScriptTagService.check_or_insert_tag(shop)
    end

    it 'should call ScriptTagService.insert_script' do
      allow(shop).to receive(:activate_session)
      allow(ShopifyAPI::ScriptTag).to receive(:all).and_return(
        OpenStruct.new('id': 1, 'src': 'https:\/\/djavaskripped.org\/fancy.js')
      )
      expect(ScriptTagService).to receive(:insert_script).with(shop)
      ScriptTagService.check_or_insert_tag(shop)
    end
  end
end
