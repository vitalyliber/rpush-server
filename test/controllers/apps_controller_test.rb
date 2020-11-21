require 'test_helper'

class AppsControllerTest < ActionDispatch::IntegrationTest
  test 'create new APNS app' do
    post apps_path,
         params: {
           app: {
             os: 'ios',
             certificate:
               File.read("#{Rails.root}/test/fixtures/files/apns.pem"),
             environment: 'development',
             password: 'password',
             connections: 1
           }
         },
         headers: server_access_headers

    assert_response 201
    assert_equal '{}', body
    assert_equal 1, Rpush::Apns::App.count

    delete app_path(Rpush::Apns::App.last.id),
           params: { os: 'ios' }, headers: server_access_headers

    assert_response 200
    assert_equal '{}', body
    assert_equal 0, Rpush::Apns::App.count
  end

  test 'create new APNS8 app' do
    mobile_accesses(:one).update!(apns_version: 'apnsp8')
    apn_key =
      '
-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM09AwEHBHkwdwIBAQQgl4ErDpQ0F2L7ugtR
ZPQcitFuGkKSAA93Je9VrG1AQknmCgYIKoZIzj0DAQehRANCAASU8Cj+YD12bbi5
Rgcyapnf9XWBUlB6cb6xRaFF9D0O17P5vf6UdzWvlXyuokrM9qhvwsG4aFomBZYj
V8LRZVm4
-----END PRIVATE KEY-----
'
    post apps_path,
         params: {
           app: {
             os: 'ios',
             apn_key: apn_key,
             apn_key_id: 'CNX38P272R',
             team_id: '9P59H549VX',
             bundle_id: 'com.casply.irregular',
             environment: 'development',
             connections: 1
           }
         },
         headers: server_access_headers

    assert_response 201
    assert_equal '{}', body
    assert_equal 1, Rpush::Apnsp8::App.count

    delete app_path(Rpush::Apnsp8::App.last.id),
           params: { os: 'ios' }, headers: server_access_headers

    assert_response 200
    assert_equal '{}', body
    assert_equal 0, Rpush::Apnsp8::App.count
  end

  test 'create new android app' do
    post apps_path,
         params: {
           app: { os: 'android', auth_key: 'someAuthKey', connections: 1 }
         },
         headers: server_access_headers

    assert_response 201
    assert_equal '{}', body
    assert_equal 1, Rpush::Gcm::App.count

    delete app_path(Rpush::Gcm::App.last.id),
           params: { os: 'android' }, headers: server_access_headers

    assert_response 200
    assert_equal '{}', body
    assert_equal 0, Rpush::Gcm::App.count
  end

  test 'unsuccessful destroy' do
    delete app_path(123),
           params: { os: 'android' }, headers: server_access_headers

    assert_response 404
    assert_equal 0, Rpush::Gcm::App.count
  end
end
