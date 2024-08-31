module AlertsHelper
  def send_alert_to_telegram(message)
    # Skip some messages here (they are not errors)
    return if message.include?("PG::UniqueViolation")

    send_telegram_message("An error occurred in the RPush Server:")
    send_telegram_message(message)
  end
  def send_telegram_message(message)
    if Rails.env.production?
      link = "#{ENV["ALERTS_HOOK"]}#{CGI.escape(message).truncate(4096)}"

      with_retries(max_attempts: 10) do
        Excon.get(link)
      end
    end
  end

  def with_retries(max_attempts: 5, &block)
    attempts = 0

    begin
      sleep 1
      attempts += 1
      yield
    rescue => e
      if attempts < max_attempts
        Rails.logger.warn("Attempt #{attempts} failed: #{e.message}. Retrying...")
        retry
      else
        Rails.logger.error("All #{max_attempts} attempts failed: #{e.message}")
        # raise
      end
    end
  end
end
