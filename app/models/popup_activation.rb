class PopupActivation < ActiveRecord::Base
  belongs_to :shop

  before_create :generate_session_token


  private


  def generate_session_token
    self.session_token = SecureRandom.base64(50)
  end
end
