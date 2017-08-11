class PopupSubmitMailer < ApplicationMailer
  default from: 'from@example.com'

  def welcome_email(popup_submit)
    @popup_submit = popup_submit
    email_with_name = %("#{@popup_submit.name}" <#{@popup_submit.email}>)
    mail(to: email_with_name, subject: 'Your Discount')
  end
end
