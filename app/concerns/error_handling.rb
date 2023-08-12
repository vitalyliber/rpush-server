module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :log_error
  end

  private

  def log_error(error)
    Rails.logger.error("An error occurred: #{error.message}")
    Excon.get("#{ENV["ALERTS_HOOK"]}An error occurred:")
    link = "#{ENV["ALERTS_HOOK"]}#{CGI.escape(error.message.gsub('`', '').gsub('\'', ''))}"
    Excon.get(link)

    raise error
  end
end
