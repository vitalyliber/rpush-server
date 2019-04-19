## Auth

Generate mobile_token in the rails console:

```ruby
MobileAccess.create(app_name: 'app', email: 'your@mail.com')
```

Fill credentials on the main page (includes instructions for APNS and Firebase)


## Endpoints

* [POST /mobile_devices](#create-mobile-device)
* [DELETE /mobile_device/:push_token](#remove-mobile-device)
* [POST /push_notifications](#create-push-notifications)

### Create mobile device

_Run this method every time after start a mobile application_

POST `/mobile_devices`
Params:

```json5
{
    "mobile_device": {
        "device_token": "mobile_device_push_token",
        "device_type": "ios" // ios/android
    },
    "mobile_user": {
        "external_key": 123, // server user identifier
        "environment": "development" // development/production
    }
}
```

Headers:

```json5
{ Authorization: "Bearer client_token" }
```

Response:

```json5
{}
```
Response status: `200`

### Remove mobile device

_Run this method through user logout_

DELETE `/mobile_device/:push_token`

Response:

```json5
{}
```
Response status: `200`

### Create push notifications 

_(for every user devices)_

_Run this method on the server side_

POST `/push_notifications`
Params:

```json5
{
    "message": {
        "title": "New message",
        "message": "Hello Mark"
    },
    "mobile_user": {
        "external_key": 123, // server user identifier
        "environment": "development" // development/production
    },
    device_type: 'ios' // ios/android/all
}
```

Headers:

```json5
{ Authorization: "Bearer server_token" }
```

Response:

```json5
{}
```
Response status: `200`