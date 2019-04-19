require 'test_helper'

class MobileDevicesControllerTest < ActionDispatch::IntegrationTest
  test "create new ios device" do
    device_token = 'febdb20eee690413baf649482664e7bbe0313f27f9959cf705bdbe8e79e0a5a4'
    post mobile_devices_path,
         params: {
             mobile_device: {
                 device_token: device_token,
                 device_type: 'ios',
             },
             mobile_user: {
                 external_key: 'martin',
                 environment: 'development'
             }
         },
         headers: client_access_headers

    assert_response 200
    assert_equal '{}', body
    assert_equal 2, MobileDevice.count
    last_mobile_device = MobileDevice.last.mobile_user
    assert_equal last_mobile_device.external_key, 'martin'
    assert_equal last_mobile_device.environment, 'development'

    # resignin on the same device for another user
    post mobile_devices_path,
         params: {
             mobile_device: {
                 device_token: device_token,
                 device_type: 'ios',
             },
             mobile_user: {
                 external_key: 'alice',
                 environment: 'development'
             }
         },
         headers: client_access_headers

    assert_response 200
    assert_equal MobileDevice.find_by(device_token: device_token).mobile_user.external_key, 'alice'
    assert_equal 2, MobileDevice.count

    # reject empty external_key
    post mobile_devices_path,
         params: {
             mobile_device: {
                 device_token: device_token,
                 device_type: 'ios',
             },
             mobile_user: {
                 environment: 'development'
             }
         },
         headers: client_access_headers

    assert_response 404
    assert_equal body, "{\"error\":\"Validation failed: External key can't be blank\"}"
    assert_equal MobileDevice.find_by(device_token: device_token).mobile_user.external_key, 'alice'
    assert_equal 2, MobileDevice.count

    #remove mobile device
    delete mobile_device_path(device_token),
         headers: client_access_headers
    assert_response 200
    assert_nil MobileDevice.find_by(device_token: device_token)
  end

  test "create new android device" do
    device_token = 'cda2GMo7I8M:APA91bG8-9bomkAx9ZKjyzjG6OLNuTS4OGVfMP5rPp36Gl6IsN0IZNDyyNWCLSMZZ0uN_7MMKaIVUW61a3BHNVWkM7VlOmDosJfetGd-M1VrLctdmX64r4HOwfL0OuDw1dSN49KcN6GY'
    post mobile_devices_path,
         params: {
             mobile_device: {
                 device_token: device_token,
                 device_type: 'android',
             },
             mobile_user: {
                 external_key: 'martin',
                 environment: 'production',
             }
         },
         headers: client_access_headers

    assert_response 200
    assert_equal '{}', body
    assert_equal 3, MobileDevice.count
    last_mobile_device = MobileDevice.last.mobile_user
    assert_equal last_mobile_device.external_key, 'martin'
    assert_equal last_mobile_device.environment, 'production'

    # resignin on the same device for another user
    post mobile_devices_path,
         params: {
             mobile_device: {
                 device_token: device_token,
                 device_type: 'android',
             },
             mobile_user: {
                 external_key: 'alice',
             }
         },
         headers: client_access_headers

    assert_response 200
    assert_equal MobileDevice.find_by(device_token: device_token).mobile_user.external_key, 'alice'
    assert_equal 3, MobileDevice.count

    # reject empty external_key
    post mobile_devices_path,
         params: {
             mobile_device: {
                 device_token: device_token,
                 device_type: 'ios',
             },
             mobile_user: {
                 environment: 'development'
             }
         },
         headers: client_access_headers

    assert_response 404
    assert_equal body, "{\"error\":\"Validation failed: External key can't be blank\"}"
    assert_equal MobileDevice.find_by(device_token: device_token).mobile_user.external_key, 'alice'
    assert_equal 3, MobileDevice.count

    #remove mobile device
    delete mobile_device_path(device_token),
           headers: client_access_headers
    assert_response 200
    assert_nil MobileDevice.find_by(device_token: device_token)
  end
end
