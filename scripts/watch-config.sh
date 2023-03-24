#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /opt/bitnami/scripts/libapache.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load Apache environment
. /opt/bitnami/scripts/apache-env.sh

mkdir -p conf

while inotifywait -e create,delete,modify,move -r conf; do
    /opt/bitnami/scripts/apache/reload.sh;
done
