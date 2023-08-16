module AlertsHelper
  def send_alert_to_telegram(message)
    # Skip some messages here (they are not errors)
    return if message.include?("PG::UniqueViolation")

    send_telegram_message("An error occurred in the RPush Server:")
    send_telegram_message(message)
  end
  def send_telegram_message(message)
    if Rails.env.production?
      link = "#{ENV["ALERTS_HOOK"]}#{CGI.escape(message)}"
      Excon.get(link)
    end
  end
end
