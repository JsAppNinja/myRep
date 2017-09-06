require 'csv'

class PopupSubmit < ActiveRecord::Base
  PER_PAGE = 15
  belongs_to :shop

  validates :email, presence: true, length: {maximum: 255}
  validates_email_format_of :email, :message => 'is not looking good'

  def self.to_csv
    attributes = %w(email name url)

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |popup_submit|
        csv << attributes.map{ |attr| popup_submit.send(attr) }
      end
    end
  end
end
