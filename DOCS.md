# Wealthfolio app documentation

## Authentication

Authentication is disabled by default. To enable it, set `auth_required` to
`true` and provide an Argon2id hash with an Argon2 tool, for example:

```sh
printf 'your-password' | argon2 'a-long-random-salt' -id -e
```

Store the complete resulting hash in `auth_password_hash`. When authentication
is enabled, `cors_allow_origins` is also required and must match the Home
Assistant origin exactly, including scheme and port.

## Ingress

The server listens on port 8089 internally and is exposed through an internal
Nginx reverse proxy on port 8088 for Home Assistant ingress. No host port is
declared.

Set `cors_allow_origins` to the Home Assistant origin exactly, including scheme
and port. A wildcard is not appropriate when authentication is enabled.

The server also accepts these options from `config.json` and exports them to
Wealthfolio as environment variables:

- `auth_token_ttl_minutes`: token lifetime in minutes; default `60`.
- `request_timeout_ms`: request timeout in milliseconds; default `30000`.
- `cookie_secure`: cookie security mode; default `auto`.

The server listens on `127.0.0.1:8089` inside the container and stores its
database at `/data/wealthfolio.db`.

## Persistent data and secrets

Home Assistant persists `/data`, which contains the SQLite database and encrypted
secrets. If `secret_key` is omitted, the run script generates one and saves it
to the app configuration. Keep a backup of the app data and `secret_key`
together. Changing or losing the key makes existing encrypted secrets
unreadable.

## Updating

The app currently pins `wealthfolio/wealthfolio:3.6.3`. Update the version,
test ingress thoroughly, and publish matching architecture images before changing
the app version.
