require 'test_helper'

def create_apns_app
  Rpush::Apns::App.find_or_create_by!(
      name: MobileAccess.find_by(server_token: 'one').app_name,
      environment: 'development',
      certificate: File.read("#{Rails.root}/test/fixtures/files/apns.pem")
  )
end

def create_gcm_app
  Rpush::Gcm::App.find_or_create_by!(
      name: MobileAccess.find_by(server_token: 'one').app_name,
      auth_key: 'xyz'
  )
end

class PushNotificationsControllerTest < ActionDispatch::IntegrationTest
  test "create push notification to all platforms" do
    assert_equal Rpush::Apns::Notification.count, 0
    assert_equal Rpush::Gcm::Notification.count, 0
    create_apns_app
    create_gcm_app

    post push_notifications_path,
         params: {
             mobile_user: {
                 external_key: 'LiberVA',
                 environment: 'development'
             },
             message: {
                 title: 'New guests apply',
                 message: 'Angela has applied to you event'
             }
         },
         headers: server_access_headers
    assert_equal Rpush::Apns::Notification.count, 1
    assert_equal Rpush::Gcm::Notification.count, 1
    assert_response 200
    assert_equal '{}', body
  end

  test "create push notification to android" do
    assert_equal Rpush::Apns::Notification.count, 0
    assert_equal Rpush::Gcm::Notification.count, 0
    create_gcm_app
    post push_notifications_path,
         params: {
             mobile_user: {
                 external_key: 'LiberVA',
                 environment: 'development'
             },
             message: {
                 title: 'New guests apply',
                 message: 'Angela has applied to you event'
             },
             device_type: 'android'
         },
         headers: server_access_headers
    assert_equal Rpush::Apns::Notification.count, 0
    assert_equal Rpush::Gcm::Notification.count, 1
    assert_response 200
    assert_equal '{}', body
  end

  test "create push notification to ios" do
    assert_equal Rpush::Apns::Notification.count, 0
    assert_equal Rpush::Gcm::Notification.count, 0
    create_apns_app
    post push_notifications_path,
         params: {
             mobile_user: {
                 external_key: 'liberva', # external key is case insensitive
                 environment: 'development'
             },
             message: {
                 title: 'New guests apply',
                 message: 'Angela has applied to you event'
             },
             device_type: 'ios'
         },
         headers: server_access_headers
    assert_equal Rpush::Apns::Notification.count, 1
    assert_equal Rpush::Gcm::Notification.count, 0
    assert_response 200
    assert_equal '{}', body
  end
end
