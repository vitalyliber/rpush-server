require 'test_helper'

class MobileAccessTest < ActiveSupport::TestCase
  test "generate token before save model" do
    mobile_access = MobileAccess.new(app_name: 'GovernmentApp', email: 'some@email.com')
    mobile_access.save
    assert mobile_access.reload.server_token.present?
    assert mobile_access.reload.client_token.present?
  end
end
