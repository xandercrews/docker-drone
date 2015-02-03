#!/bin/sh

perl -p -i -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' < /etc/drone/drone.toml
/usr/sbin/init
