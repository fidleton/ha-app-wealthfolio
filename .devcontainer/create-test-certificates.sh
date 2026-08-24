#!/usr/bin/env bash

set -euo pipefail

ssl_dir="${SSL_DIR:-/mnt/supervisor/ssl}"
certificate="${ssl_dir}/fullchain.pem"
private_key="${ssl_dir}/privkey.pem"

if [[ -r "${certificate}" && -r "${private_key}" ]]; then
	printf 'Test certificates already exist in %s\n' "${ssl_dir}"
	exit 0
fi

mkdir -p "${ssl_dir}"
temporary_directory=$(mktemp -d)
trap 'rm -rf "${temporary_directory}"' EXIT

openssl req \
	-x509 \
	-nodes \
	-newkey rsa:2048 \
	-days 3650 \
	-keyout "${temporary_directory}/privkey.pem" \
	-out "${temporary_directory}/fullchain.pem" \
	-subj '/CN=localhost' \
	-addext 'subjectAltName=DNS:localhost,IP:127.0.0.1,IP:::1'

chmod 600 "${temporary_directory}/privkey.pem"
chmod 644 "${temporary_directory}/fullchain.pem"
mv "${temporary_directory}/privkey.pem" "${private_key}"
mv "${temporary_directory}/fullchain.pem" "${certificate}"

printf 'Created self-signed test certificates in %s\n' "${ssl_dir}"