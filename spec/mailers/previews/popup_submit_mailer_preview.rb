# The preview be available in http://localhost:3000/rails/mailers/popup_submit_mailer/welcome_email
class PopupSubmitMailerPreview < ActionMailer::Preview
  def welcome_email
    PopupSubmitMailer.welcome_email(PopupSubmit.last)
  end
end
