require 'test_helper'

def create_apns_app
  Rpush::Apns::App.find_or_create_by!(
    name: MobileAccess.find_by(server_token: 'one').app_name,
    environment: 'development',
    certificate: File.read("#{Rails.root}/test/fixtures/files/apns.pem")
  )
end

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
    environment: 'development',
  )
end

def create_gcm_app
  Rpush::Gcm::App.find_or_create_by!(
    name: MobileAccess.find_by(server_token: 'one').app_name, auth_key: 'xyz'
  )
end

class PushNotificationsControllerTest < ActionDispatch::IntegrationTest
  test 'create push notification to all platforms' do
    assert_equal Rpush::Apns::Notification.count, 0
    assert_equal Rpush::Gcm::Notification.count, 0
    create_apns_app
    create_gcm_app

    post push_notifications_path,
         params: {
           mobile_user: { external_key: 'LiberVA', environment: 'development' },
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

  test 'create push notification to android' do
    assert_equal Rpush::Apns::Notification.count, 0
    assert_equal Rpush::Gcm::Notification.count, 0
    create_gcm_app
    post push_notifications_path,
         params: {
           mobile_user: { external_key: 'LiberVA', environment: 'development' },
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

  test 'create push notification to ios apns' do
    assert_equal Rpush::Apns::Notification.count, 0
    assert_equal Rpush::Gcm::Notification.count, 0
    create_apns_app
    post push_notifications_path,
         params: {
           mobile_user: {
             external_key: 'liberva',
             # external key is case insensitive
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

  test 'create push notification to ios apnsp8' do
    mobile_accesses(:one).update!(apns_version: 'apnsp8')
    assert_equal Rpush::Apnsp8::Notification.count, 0
    assert_equal Rpush::Gcm::Notification.count, 0
    create_apnsp8_app
    post push_notifications_path,
         params: {
           mobile_user: {
             external_key: 'liberva',
             # external key is case insensitive
             environment: 'development'
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

  test 'create push notification to all devices' do
    assert_equal Rpush::Apns::Notification.count, 0
    assert_equal Rpush::Gcm::Notification.count, 0
    create_apns_app
    create_gcm_app
    post push_notifications_path,
         params: {
           mobile_user: {
             external_key: 'LiberVA',
             # external key is case insensitive
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
    post push_notifications_path,
         params: {
           mobile_user: { environment: 'development' },
           message: {
             title: 'New guests apply',
             message: 'Angela has applied to you event'
           }
         },
         headers: server_access_headers
    assert_response :success
    assert_equal Rpush::Apns::Notification.count, 2
    assert_equal Rpush::Gcm::Notification.count, 2
    assert_response 200
    assert_equal '{}', body
  end
end
