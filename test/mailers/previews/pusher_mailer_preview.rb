# Preview all emails at http://localhost:3000/rails/mailers/pusher_mailer
class PusherMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/pusher_mailer/ssl_will_expire
  def ssl_will_expire
    PusherMailer.ssl_will_expire('wow@gmail.com', 'app_name', Time.now)
  end

  # Preview this email at http://localhost:3000/rails/mailers/pusher_mailer/ssl_was_revoked
  def ssl_was_revoked
    PusherMailer.ssl_was_revoked('wow@gmail.com', 'app_name')
  end

end
