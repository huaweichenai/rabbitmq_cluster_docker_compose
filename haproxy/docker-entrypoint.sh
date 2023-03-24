#!/bin/sh
set -e

sed -i "s/\$HAPROXY_AUTH_USER/$HAPROXY_AUTH_USER/g" /usr/local/etc/haproxy/haproxy.cfg
sed -i "s/\$HAPROXY_AUTH_PASS/$HAPROXY_AUTH_PASS/g" /usr/local/etc/haproxy/haproxy.cfg

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- haproxy "$@"
fi

if [ "$1" = 'haproxy' ]; then
	shift # "haproxy"
	# if the user wants "haproxy", let's add a couple useful flags
	#   -W  -- "master-worker mode" (similar to the old "haproxy-systemd-wrapper"; allows for reload via "SIGUSR2")
	#   -db -- disables background mode
	set -- haproxy -W -db "$@"
fi

exec "$@"
