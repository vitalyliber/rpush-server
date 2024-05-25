require 'test_helper'

class AccessesControllerTest < ActionDispatch::IntegrationTest
  test 'create new android app' do
    get accesses_path, { headers: server_access_headers }

    assert_response 200
    assert_equal 'one', easy_body.app_name
  end
end
