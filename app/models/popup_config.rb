class PopupConfig < ApplicationRecord
  SERVICE_SETTINGS = {
    uri_filters: {
      allowed_types: %w(Does Doesn't),
      allowed_matching_types: ['match', 'contain', 'begin with', 'end with']
    }
  }

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
end