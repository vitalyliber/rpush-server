require 'test_helper'

def create_apnsp8_app
  apn_key =
    '
-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM09AwEHBHkwdwIBAQQgl4ErDpQ0F2L7ugtR
ZPQcitFuGkKSAA93Je9VrG1AQknmCgYIKoZIzj0DAQehRANCAASU8Cj+YD12bbi5
Rgcyapnf9XWBUlB6cb6xRaFF9D0O17P5vf6UdzWvlXyuokrM9qhvwsG4aFomBZYj
V8LRZVm4
-----END PRIVATE KEY-----
'
  Rpush::Apnsp8::App.find_or_create_by!(
    name: MobileAccess.find_by(server_token: 'one').app_name,
    apn_key: apn_key,
    apn_key_id: 'CNX38P272R',
    team_id: '9P59H549VX',
    bundle_id: 'com.casply.irregular',
    environment: 'production',
  )
end

def create_gcm_app
  Rpush::Gcm::App.find_or_create_by!(
    name: MobileAccess.find_by(server_token: 'one').app_name, auth_key: 'xyz'
  )
end

class PushNotificationsControllerTest < ActionDispatch::IntegrationTest
  test 'send push notifications to all platforms' do
    assert_equal Rpush::Apnsp8::Notification.count, 0
    assert_equal Rpush::Gcm::Notification.count, 0
    create_apnsp8_app
    create_gcm_app

    post push_notifications_path,
         params: {
           mobile_user: {
             external_key: 'LiberVA',
             environment: 'production'
           },
           message: {
             title: 'New guests apply',
             message: 'Angela has applied to you event'
           }
         },
         headers: server_access_headers
    assert_equal Rpush::Apnsp8::Notification.count, 1
    assert_equal Rpush::Gcm::Notification.count, 1
    assert_response 200
    assert_equal '{}', body
  end

  test 'send push notifications to android' do
    assert_equal Rpush::Apnsp8::Notification.count, 0
    assert_equal Rpush::Gcm::Notification.count, 0
    create_gcm_app
    post push_notifications_path,
         params: {
           mobile_user: { external_key: 'LiberVA', environment: 'production' },
           message: {
             title: 'New guests apply',
             message: 'Angela has applied to you event',
             data: {
               data_param: 'value'
             },
             data_notification: {
               data_notification_param: 'value'
             }
           },
           device_type: 'android',
         },
         headers: server_access_headers
    assert_equal Rpush::Apnsp8::Notification.count, 0
    assert_equal Rpush::Gcm::Notification.count, 1
    assert_response 200
    assert_equal '{}', body
    # Verify that data parameters are successfully merged
    lastNotification = Rpush::Gcm::Notification.last
    assert lastNotification.notification['data_notification_param']
    assert lastNotification.data.dig('data', 'data_param')
  end

  test 'send push notifications for apnsp8' do
    assert_equal Rpush::Apnsp8::Notification.count, 0
    assert_equal Rpush::Gcm::Notification.count, 0
    create_apnsp8_app
    post push_notifications_path,
         params: {
           mobile_user: {
             external_key: 'liberva',
             # external key is case insensitive
             environment: 'production'
           },
           message: {
             title: 'New guests apply',
             message: 'Angela has applied to you event'
           },
           device_type: 'ios'
         },
         headers: server_access_headers
    assert_equal '{}', body
    assert_response 200
    # assert_equal Rpush::Apnsp8::Notification.count, 1
    assert_equal Rpush::Gcm::Notification.count, 0
  end

  test 'send push notification to all devices' do
    assert_equal Rpush::Apnsp8::Notification.count, 0
    assert_equal Rpush::Gcm::Notification.count, 0
    create_apnsp8_app
    create_gcm_app
    post push_notifications_path,
         params: {
           mobile_user: {
             external_key: 'LiberVA',
             environment: 'production'
           },
           message: {
             title: 'New guests apply',
             message: 'Angela has applied to you event'
           }
         },
         headers: server_access_headers
    assert_equal Rpush::Apnsp8::Notification.count, 1
    assert_equal Rpush::Gcm::Notification.count, 1
    # send to all devices
    post push_notifications_path,
         params: {
           mobile_user: { environment: 'production' },
           message: {
             title: 'New guests apply',
             message: 'Angela has applied to you event'
           }
         },
         headers: server_access_headers
    assert_response :success
    assert_equal Rpush::Apnsp8::Notification.count, 2
    assert_equal Rpush::Gcm::Notification.count, 2
    assert_response 200
    assert_equal '{}', body
  end
end
