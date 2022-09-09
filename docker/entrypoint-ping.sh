#!/usr/bin/env -S /bin/bash -l
set -e
if [ "$#" -eq 0 ]; then
  # ping the server in env
  /bin/mumble-ping -json $SERVER_DOMAIN
else
  # run the given command
  exec "$@"
fi
