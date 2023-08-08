
# Rpush-server

<img src="/logo.jpg" align="right"
     alt="Rpush-server logo by Shen">

A simple push server implementation based on [**RPush**](https://github.com/rpush/rpush).

* **Simple.** Has an admin panel for managing push notifications credentials, users and push tokens.
* **Powerful.** Has all API methods for keeping push tokens and sending messages.
* **No DevOps needed.** Easy deploy to Heroku or Dokku.

Read more about RPush-server features in [**our docs**](docs/api/API.md)

The RPush server admin panel is accessible by the [link](http://localhost:3000/admin).

Configure environment variables to protect the admin panel:

```console
ADMIN_USERNAME=admin_username
ADMIN_PASSWORD=admin_password
```

## Run the RPush server in development mode.
     
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

## Restore production backup for local development purposes.

```console
 pg_restore --verbose --clean --no-acl --no-owner -U postgres -d rpush_server_dev < [path_to_backup]
```
