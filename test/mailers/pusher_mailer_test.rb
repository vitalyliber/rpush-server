require 'test_helper'

class PusherMailerTest < ActionMailer::TestCase
  test "ssl_will_expire" do
    mail = PusherMailer.ssl_will_expire('to@example.org', 'app_name', Time.now)
    assert_equal "Ssl will expire", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_nil ENV["MAILER_FROM"] # mail.from
  end

  test "ssl_was_revoked" do
    mail = PusherMailer.ssl_was_revoked('to@example.org', 'app_name')
    assert_equal "Ssl was revoked", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_nil ENV["MAILER_FROM"] # mail.from
  end

end
