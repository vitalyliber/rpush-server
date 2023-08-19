module ErrorHandling
  extend ActiveSupport::Concern
  include AlertsHelper

  included do
    rescue_from StandardError, with: :log_error
  end

  private

  def log_error(error)
    Rails.logger.error("An error occurred: #{error.message}")
    send_alert_to_telegram(error.message)

    raise error
  end
end
