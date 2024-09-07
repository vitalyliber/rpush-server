class ApplicationJob  < ActiveJob::Base
  include AlertsHelper
  def handle_exceptions(raise_error: true, &block)
    begin
      yield
    rescue => error
      Rails.logger.error("An error occurred: #{error.message}")
      send_alert_to_telegram(error.message)

      raise error if raise_error
    end
  end
end
