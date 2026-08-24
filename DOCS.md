# Wealthfolio app documentation

## Configuration

The configurable app options are:

- `secret_key`: optional. When omitted, the app generates a key on first start
  and persists it in the app configuration.
- `authentication.username`: username required for direct HTTPS access through
  the external port; defaults to `wealthfolio`.
- `authentication.password`: password required for direct HTTPS access through
  the external port.
- `ssl_tls.certificate_file`: certificate filename in `/ssl`; default
  `fullchain.pem`.
- `ssl_tls.private_key_file`: private key filename in `/ssl`; default
  `privkey.pem`.

Back up `secret_key` together with the app data. Changing or losing it makes
existing encrypted secrets unreadable.

## Ingress

The server listens on port 8089 internally and is exposed through Nginx on
container port 8088 for Home Assistant ingress. Direct HTTP host access is not
supported.

The server uses the configured files in `/ssl` for HTTPS. If either file is not
available at startup, the HTTPS listener is disabled. To enable direct HTTPS
access, choose a host port for `8443/tcp` in the add-on's **Network** settings
and access `https://<home-assistant-host>:<port>`.
Direct HTTPS access is protected with HTTP Basic Authentication. Home Assistant
ingress access through port 8088 is unchanged.

The server listens on `127.0.0.1:8089` inside the container and stores its
database at `/data/wealthfolio.db`.

## Persistent data

Home Assistant persists `/data`, which contains the SQLite database and
encrypted secrets. The database is stored at `/data/wealthfolio.db`.

## Updating

The app currently pins `wealthfolio/wealthfolio:3.6.3`. Update the version,
test ingress thoroughly, and publish matching architecture images before changing
the app version.
