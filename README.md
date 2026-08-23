# Home Assistant app: Wealthfolio

Wealthfolio is a private portfolio tracker that stores its data locally.

This app runs Wealthfolio behind an internal Nginx reverse proxy for Home
Assistant ingress. It does not publish an independent host port.

## Installation

Add this repository to Home Assistant, install the Wealthfolio app, then start
it. Open the application with Home Assistant's **Open Web UI** button.

Authentication is disabled by default. If you enable it, configure an Argon2id
password hash and the Home Assistant origin in `cors_allow_origins`.

The app supports `amd64` and `aarch64` hosts.

## Configuration

- `secret_key`: optional. The app generates and persists a key automatically on
	first start when this is omitted.
- `auth_password_hash`: required only when `auth_required` is `true`; use an
	Argon2id PHC password hash.
- `cors_allow_origins`: required only when `auth_required` is `true`; set it to
	the Home Assistant origin, including scheme and port.

Back up `secret_key`. Losing it makes encrypted credentials in the data volume
unrecoverable. The app listens internally on port 8089 behind the Nginx proxy
and is exposed through Home Assistant ingress; no host port is published.

See [DOCS.md](DOCS.md) for configuration and backup details.

## Local development

Use the repository's Dev Container so you get the nested Docker daemon and Home
Assistant Supervisor tooling expected by Home Assistant app development.

1. Install the Dev Containers extension.
2. Open this repository in VS Code and run **Dev Containers: Reopen in
   Container**.
3. Start the local Home Assistant Supervisor from the container terminal:

   ```sh
   supervisor_run
   ```

   Alternatively, use the VS Code task **Start Home Assistant**.
4. Prepare the local app environment so Supervisor builds this checkout instead
   of using the published registry image:

   ```sh
   .devcontainer/prepare-local-addon.sh
   ```

   Alternatively, use the VS Code task **Prepare local App environment**. This
   removes the `image` field from `config.json` temporarily so the current
   checkout's `Dockerfile` is built and the app is installed as a local add-on.
5. Open the app through Home Assistant's **Open Web UI** ingress button.

The devcontainer configures `1.1.1.1` for the nested Home Assistant
Supervisor. If your host uses a VPN or corporate network, replace this with a
DNS server reachable from that environment.

This project does not include a standalone local server command. The supported
workflow is to run the app through Home Assistant's local Supervisor integration
inside the devcontainer.
