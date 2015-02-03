#!/bin/sh

# populate configuration templates from environment
if [ ! -z "/etc/drone/drone.toml.tmpl" ]; then
    perl -p -i -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' < /etc/drone/drone.toml.tmpl > /etc/drone/drone.toml
fi

# wait for the postgres database to accept connections
for i in seq 60; do 
	/usr/pgsql-9.3/bin/pg_isready -d ${POSTGRESQL_ENV_DB_NAME} -h ${POSTGRESQL_PORT_5432_TCP_ADDR} -p ${POSTGRESQL_PORT_5432_TCP_PORT} -U ${POSTGRESQL_ENV_DB_USER} 1>/dev/null 2>/dev/null && break
	sleep 1
done

# run systemd
exec /usr/sbin/init

# vim: set ts=4 sw=4 expandtab:
