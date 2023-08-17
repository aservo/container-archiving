#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

mkdir -p conf

while inotifywait -e create,delete,modify,move -r conf; do
    /opt/bitnami/scripts/apache/reload.sh;
done

# if the loop aborts, create a file 'watch-config-failed' in the conf directory
touch conf/watch-config-failed
