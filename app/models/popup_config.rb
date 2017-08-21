class PopupConfig < ApplicationRecord
  SERVICE_SETTINGS = {
    uri_filters: {
      allowed_types: %w(Does Doesn't),
      allowed_matching_types: ['match', 'contain', 'begin with', 'end with']
    }
  }

  belongs_to :shop

  validates  :shop_id, presence: true
  validate   :validate_uri_filters

  enum placement: %w(left right top bottom)


  def self.service_settings(key = nil, hash=SERVICE_SETTINGS)
    return hash if key == nil

    found = nil

    if hash.respond_to?(:key?) && hash.key?(key)
      return hash[key]
    elsif hash.is_a? Enumerable
      hash.find { |*a| found = service_settings(key, a.last) }
      return found
    end
  end

  def validate_uri_filters
    uri_filters.each do |rule|
      errors.add(:uri_filters, 'invalid type of uri_filter') unless
        PopupConfig.service_settings(:allowed_types).include?(rule['type'])

      errors.add(:uri_filters, 'invalid matching type of uri_filter') unless
        PopupConfig.service_settings(:allowed_matching_types).include?(rule['matching'])

      errors.add(:uri_filters, 'uri can\'t be blank') if rule['uri'].blank?
    end
  end

  def js_required_settings
    {
      desktop_enabled:         self.desktop_enabled,
      desktop_show_on_leave:   self.desktop_show_on_leave,
      desktop_show_on_timeout: self.desktop_show_on_timeout,
      desktop_show_timeout:    self.desktop_show_timeout,
      tablet_enabled:          self.tablet_enabled,
      tablet_show_on_leave:    self.tablet_show_on_leave,
      tablet_show_on_timeout:  self.tablet_show_on_timeout,
      tablet_show_timeout:     self.tablet_show_timeout,
    }.to_json
  end
end