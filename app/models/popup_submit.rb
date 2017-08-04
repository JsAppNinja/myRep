class PopupSubmit < ActiveRecord::Base
  PER_PAGE = 15
  belongs_to :shop

  validates :email, presence: true, length: {maximum: 255}
  validates_email_format_of :email, :message => 'is not looking good'
end
