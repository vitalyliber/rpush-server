class ApplicationJob  < ActiveJob::Base
  include AlertsHelper
  def handle_exceptions(&block)
    begin
      yield
    rescue => error
      Rails.logger.error("An error occurred: #{error.message}")
      send_alert_to_telegram(error.message)

      raise error
    end
  end
end
