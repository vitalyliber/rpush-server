class PusherMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.pusher_mailer.ssl_will_expire.subject
  #
  def ssl_will_expire(email, app_name, expiration_time)
    @app_name = app_name
    @expiration_time = expiration_time
    mail to: email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.pusher_mailer.ssl_was_revoked.subject
  #
  def ssl_was_revoked(email, app_name)
    @app_name = app_name
    mail to: email
  end
end
