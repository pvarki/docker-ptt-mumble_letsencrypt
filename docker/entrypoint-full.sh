#!/usr/bin/env -S /usr/bin/bash -l
set -e
if [ "$#" -eq 0 ]; then
  # check cert
  . /murmurdata/scripts/check_cert.sh
  # create configs from templates using gomplate
  cat /murmurdata/templates/server-config.tpl | gomplate >/murmurdata/config.ini
  if [ ! -z "$SUPERUSER_PASSWORD" ]
  then
    /usr/sbin/murmurd -v -fg -ini /murmurdata/config.ini -supw "$SUPERUSER_PASSWORD"
  fi
  # launch server in fg
  /usr/sbin/murmurd -v -fg -ini /murmurdata/config.ini
else
  # run the given command
  exec "$@"
fi
