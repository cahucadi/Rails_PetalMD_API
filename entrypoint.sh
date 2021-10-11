#!/bin/bash
set -e

rm -f /petalmd/tmp/pids/server.pid

exec "$@"