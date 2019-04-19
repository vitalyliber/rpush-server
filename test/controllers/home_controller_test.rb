require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index without auth" do
    get root_path
    assert_response :success
  end

  test "should not get index without auth" do
    ENV['DEVELOPER_USERNAME'] = 'developer'
    ENV['DEVELOPER_PASSWORD'] = 'password'
    get root_path
    assert_response :unauthorized
    ENV['DEVELOPER_USERNAME'] = nil
    ENV['DEVELOPER_PASSWORD'] = nil
  end

  test "should get index via auth" do
    ENV['DEVELOPER_USERNAME'] = 'developer'
    ENV['DEVELOPER_PASSWORD'] = 'password'
    login_with_pass = Base64.encode64("#{ENV['DEVELOPER_USERNAME']}:#{ENV['DEVELOPER_PASSWORD']}")
    get root_path,
        headers: {"Authorization" => "Basic #{login_with_pass}"}
    assert_response :success
    ENV['DEVELOPER_USERNAME'] = nil
    ENV['DEVELOPER_PASSWORD'] = nil
  end
end
