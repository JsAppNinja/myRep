require "rails_helper"

RSpec.describe PopupSubmitMailer, :type => :mailer do
  describe 'welcome_email' do
    let(:shop)          { FactoryGirl.create(:shop) }
    let(:popup_submit)  { FactoryGirl.create(:popup_submit, shop: shop) }
    let(:mail)          { PopupSubmitMailer.welcome_email(popup_submit) }

    it 'should sended to popup_submit email' do
      expect(mail.to.first).to eq(popup_submit.email)
    end

    it 'should have popup_submit name in html mail' do
      expect(mail.html_part.encoded).to match("#{popup_submit.name}")
    end

    it 'should have popup_submit name in text mail' do
      expect(mail.text_part.encoded).to match("#{popup_submit.name}")
    end

  end
end
