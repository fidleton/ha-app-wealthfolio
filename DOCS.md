# Wealthfolio add-on documentation

## Authentication

Authentication is enabled by default. Generate an Argon2id hash with an Argon2
tool, for example:

```sh
printf 'your-password' | argon2 'a-long-random-salt' -id -e
```

Store the complete resulting hash in `auth_password_hash`.

## Ingress

The server listens on port 8088 internally and is exposed only through Home
Assistant ingress. No host port is declared, and this add-on intentionally does
not install Nginx or another reverse proxy.

Set `cors_allow_origins` to the Home Assistant origin exactly, including scheme
and port. The add-on requires this value when authentication is enabled. A
wildcard is not appropriate when authentication is enabled.

## Persistent data and secrets

Home Assistant persists `/data`, which contains the SQLite database and encrypted
secrets. Keep a backup of the add-on data and the configured `secret_key`
together. The secret key is not generated automatically because changing it
makes existing encrypted secrets unreadable.

## Updating

The add-on currently pins `wealthfolio/wealthfolio:3.6.3`. Update the version,
test ingress thoroughly, and publish matching architecture images before changing
the add-on version.