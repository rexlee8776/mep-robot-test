#!/bin/bash
# Copyright ETSI 2018
# See: https://forge.etsi.org/etsi-forge-copyright-statement.txt

#set -vx
#set -e

cd "$(dirname "$0")"

run_dir="$(pwd)"

./scripts/build-container.sh
./scripts/run-container.sh "${run_dir}"

exit $?
