# Rpush-server

[API docs](docs/api/API.md)

## Run in dev

1. Install postgres client tools
    ```
    brew install libpq
    ```
    
2. Install Yarn
    ```
    brew install yarn
    ```

3. Install Docker by [link](https://docs.docker.com/docker-for-mac/install/)

4. Create db and run migrations

    ```
    docker-compose up -d
    rails db:setup
    ```
    
5. Install frontend dependencies
    ```
    yarn install
    ```
    
6. Run a Procfile_dev processes

    ```
    yarn start
    ```
    
## How to get access token?

1. Open admin panel `/admin`

2. Sign in via credentials admin:admin

3. Create new `MobileAccess`

4. Copy `client_secret` and `mobile_secret`

Dont't forget configure environment variables in production:

```bash
ADMIN_USERNAME=admin_username
ADMIN_PASSWORD=admin_password
```

## How to send pushes via web panel?

1. Open root of site

2. Paste `server token`

3. Paste `external key` 

4. Submit `send the test push`

## How to send pushes from console?

```ruby
MobileUser.last.send_pushes(title: 'Hello', message: 'Wow')
```

## Configure mailer

_Need for sending notifications about apns certs problems
like an expiration or a revoke_

Set environments variables for Production

```ruby
MAILER_ADDRESS # smtp.sendgrid.net
MAILER_DOMAIN # rpush-server.com
MAILER_USER # vasya
MAILER_PASSWORD # xyz
MAILER_FROM # from@rpush-server.com
```

Mailer was tested with [sendgrid](https://app.sendgrid.com/guide/integrate/langs/smtp)

You can check how it works in console:

```ruby
PusherMailer.ssl_will_expire('your_email@gmail.com', 'app_name', Time.now).deliver_now
```