#!/usr/bin/dumb-init /bin/sh
set -e

if [ "${1:0:1}" = '-' ]; then
    set -- vault-ocsp "$@"
fi

if [ "$1" = 'vault-ocsp' ]; then
	chown -f -R vault:vault /ocsp/ssl || echo "Could not chown /ocsp/ssl (may not have appropriate permissions)"

	if [ "$(id -u)" = '0' ]; then
    	set -- su-exec vault "$@"
    fi
fi

exec "$@"
