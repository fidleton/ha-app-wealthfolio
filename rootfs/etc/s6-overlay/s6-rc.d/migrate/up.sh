#!/command/with-contenv bashio
set -e
#1. Migrate old configuration values
options=$(bashio::app.options)
old_key='authentication.username'
if bashio::jq.exists "${options}" ".${old_key}"; then
    bashio::log.info "Removing ${old_key}"
    bashio::app.option "${old_key}"
fi
old_key='authentication.password'
new_key='password'
if bashio::jq.exists "${options}" ".${old_key}"; then
    bashio::app.aption "${new_key}" "$(bashio::config "${old_key}")"
    bashio::log.info "Migrating ${old_key} to ${new_key}"
    bashio::app.option "${old_key}"
fi

certificate_file="$(bashio::config 'ssl_tls.certificate_file')"
private_key_file="$(bashio::config 'ssl_tls.private_key_file')"
password="$(bashio::config 'password')"
cors="$(bashio::config 'cors')"
port=$(bashio::app.port 8443)

# 2. Initialize variables to check configuration status (true/false)
PORT_CONFIGURED="true"
CERTIFICATE_CONFIGURED="true"
KEY_CONFIGURED="true"
PASSWORD_CONFIGURED="true"
CORS_CONFIGURED="true"
ALL_CONFIGURED="true"

if ! bashio::var.has_value "${port}"; then PORT_CONFIGURED="false"; ALL_CONFIGURED="false"; fi
if ! bashio::var.has_value "${certificate_file}" || [ ! -r "/ssl/${certificate_file}" ]; then CERTIFICATE_CONFIGURED="false"; ALL_CONFIGURED="false"; fi
if ! bashio::var.has_value "${private_key_file}" || [ ! -r "/ssl/${private_key_file}" ]; then KEY_CONFIGURED="false"; ALL_CONFIGURED="false"; fi
if ! bashio::var.has_value "${password}"; then PASSWORD_CONFIGURED="false"; ALL_CONFIGURED="false"; fi
if ! bashio::var.has_value "${cors}"; then CORS_CONFIGURED="false"; ALL_CONFIGURED="false"; fi

# 3. Write a completely safe JSON file for the frontend (NO secrets are leaked)
cat <<EOF >/var/www/localhost/htdocs/config-status.json
{
  "allConfigured": ${ALL_CONFIGURED},
  "port": "${port}",
  "options": [
    { "name": "Certificate File", "configured": ${CERTIFICATE_CONFIGURED}, "description": "The SSL/TLS certificate file for secure connections." },
    { "name": "Private Key File", "configured": ${KEY_CONFIGURED}, "description": "The SSL/TLS private key file for secure connections." },
    { "name": "Wealthfolio web interface port", "configured": ${PORT_CONFIGURED}, "description": "The local network port of the Wealthfolio web service." },
	{ "name": "Authentication", "configured": ${PASSWORD_CONFIGURED}, "description": "Wealthfolio authentication." },
	{ "name": "CORS", "configured": ${CORS_CONFIGURED}, "description": "Cross-Origin Resource Sharing (CORS) configuration." }
  ]
}
EOF



