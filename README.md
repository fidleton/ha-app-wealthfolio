# Home Assistant Add-on: Wealthfolio

Wealthfolio is a private portfolio tracker that stores its data locally.

This add-on runs Wealthfolio behind Home Assistant ingress. It does not publish
an independent host port and does not include Nginx or another proxy.

## Installation

Add this repository to Home Assistant, install the Wealthfolio add-on, configure
the required secret and password hash, then start it. Open the application with
Home Assistant's **Open Web UI** button.

The add-on supports `amd64` and `aarch64` hosts.

## Required configuration

- `secret_key`: a stable 32-byte key, generated once with `openssl rand -base64 32`.
- `auth_password_hash`: an Argon2id PHC password hash.

Back up `secret_key`. Losing it makes encrypted credentials in the data volume
unrecoverable.

See [DOCS.md](DOCS.md) for configuration and backup details.