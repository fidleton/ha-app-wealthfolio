# Wealthfolio app documentation

## Configuration

The only configurable app option is `secret_key`. It is optional: when omitted,
the app generates a key on first start and persists it in the app configuration.
Back up this key together with the app data. Changing or losing it makes
existing encrypted secrets unreadable.

## Ingress

The server listens on port 8089 internally and is exposed through Nginx on
container port 8088 for Home Assistant ingress. Direct HTTP host access is not
supported.

The server uses the Home Assistant SSL certificates mounted at
`/ssl/fullchain.pem` and `/ssl/privkey.pem` for HTTPS. If either file is not
available at startup, the HTTPS listener is disabled. To enable direct HTTPS
access, choose a host port for `8443/tcp` in the add-on's **Network** settings
and access `https://<home-assistant-host>:<port>`.

The server listens on `127.0.0.1:8089` inside the container and stores its
database at `/data/wealthfolio.db`.

## Persistent data

Home Assistant persists `/data`, which contains the SQLite database and
encrypted secrets. The database is stored at `/data/wealthfolio.db`.

## Updating

The app currently pins `wealthfolio/wealthfolio:3.6.3`. Update the version,
test ingress thoroughly, and publish matching architecture images before changing
the app version.
