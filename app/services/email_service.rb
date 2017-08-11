class EmailService
  def self.send_letter(popup_submit)
    PopupSubmitMailer.welcome_email(popup_submit)
  end
end
