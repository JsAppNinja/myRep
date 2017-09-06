require 'rails_helper'

RSpec.describe EmailService do
  describe '.send_letter' do
    let(:shop)         { FactoryGirl.create(:shop) }
    let(:popup_submit) { FactoryGirl.create(:popup_submit, shop: shop) }

    subject { EmailService.send_letter(popup_submit) }

    it 'should sended to popup_submit email' do
      expect(subject.to.first).to eq(popup_submit.email)
    end

    it 'should have popup_submit name in html mail' do
      expect(subject.html_part.encoded).to match("#{popup_submit.name}")
    end

    it 'should have popup_submit name in text mail' do
      expect(subject.text_part.encoded).to match("#{popup_submit.name}")
    end
  end
end
