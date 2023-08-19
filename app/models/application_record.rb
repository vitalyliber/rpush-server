class ApplicationRecord < ActiveRecord::Base
  include AlertsHelper

  self.abstract_class = true
  def handle_exceptions(quiet = false, callback, &block)
    begin
      yield
    rescue => error
      Rails.logger.error("An error occurred: #{error.message}")
      send_alert_to_telegram(error.message)
      callback&.call(error.message)

      raise error unless quiet
    end
  end
end
