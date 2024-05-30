
# Rpush-server

<img src="/docs/logo.jpg" align="right"
     alt="Rpush-server logo by Shen">

A simple push server implementation based on [**RPush**](https://github.com/rpush/rpush).

* **Simple.** Has an admin panel for managing push notifications credentials, users and push tokens.
* **Powerful.** Has all API methods for keeping push tokens and sending messages.
* **No DevOps needed.** Easy deploy to Heroku or Dokku.

The RPush server admin panel is accessible by the [link](http://localhost:3000/admin).

Default credentials: admin & admin

## Run the RPush server in development mode
     
1. Install dependencies
    ```console
    brew install libpq
    brew install postgresql@14
    brew install overmind
    npm install --global yarn
    yarn install
    ```

2. Create db and run migrations

    ```console
    rails db:setup
    ```
    
3. Run a Procfile_dev processes

    ```console
    yarn s
    ```

## Auth

Generate mobile_token using the admin page:

![Create mobile device](/docs/create_mobile_device.png)

Open the [app dashboard](http://localhost:5001/admin) and fill in credentials for APNS and Firebase.

![Credentials page](/docs/credentials_page.png)

## Endpoints

* [POST /mobile_devices](#create-mobile-device)
* [DELETE /mobile_device/:push_token](#remove-mobile-device)
* [POST /push_notifications](#create-push-notifications)

### Create mobile device

_Run this method every time after starting a mobile application._

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

_Run this method when the user logout._

DELETE `/mobile_device/:push_token`

Response:

```json5
{}
```
Response status: `200`

### Create push notifications

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
        "environment": "production" // development/production
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

## Restore production backup for local development purposes

```console
 pg_restore --verbose --clean --no-acl --no-owner -U postgres -d rpush_server_dev < [path_to_backup]
```
