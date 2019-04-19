require 'test_helper'

class AppsControllerTest < ActionDispatch::IntegrationTest

  test "create new ios app" do
    post apps_path,
         params: {
             app: {
                 os: 'ios',
                 certificate: File.read("#{Rails.root}/test/fixtures/files/apns.pem"),
                 environment: 'development',
                 password: 'password',
                 connections: 1
             },
         },
         headers: server_access_headers

    assert_response 201
    assert_equal '{}', body
    assert_equal 1, Rpush::Apns::App.count

    delete app_path(Rpush::Apns::App.last.id),
         params: {
             os: 'ios',
         },
         headers: server_access_headers

    assert_response 200
    assert_equal '{}', body
    assert_equal 0, Rpush::Apns::App.count
  end

  test "create new android app" do
    post apps_path,
         params: {
             app: {
                 os: 'android',
                 auth_key: 'someAuthKey',
                 connections: 1
             },
         },
         headers: server_access_headers

    assert_response 201
    assert_equal '{}', body
    assert_equal 1, Rpush::Gcm::App.count

    delete app_path(Rpush::Gcm::App.last.id),
           params: {
               os: 'android',
           },
           headers: server_access_headers

    assert_response 200
    assert_equal '{}', body
    assert_equal 0, Rpush::Gcm::App.count
  end

  test 'unsuccessful destroy' do
    delete app_path(123),
           params: {
               os: 'android',
           },
           headers: server_access_headers

    assert_response 404
    assert_equal 0, Rpush::Gcm::App.count
  end

end
