#!/bin/bash

# $1 -> if -o: starts the service with ocis
#				else: starts the service with oc10

# assumes middleware repo cloned under:
cd "$HOME"/www/owncloud-test-middleware/ || exit

if [ "$1" = "-o" ]; then
	export RUN_ON_OCIS=true
	export OCIS_REVA_DATA_ROOT="/tmp/ocis/owncloud/data"
	export BACKEND_HOST=https://localhost:9200
else
	export BACKEND_HOST=http://localhost/core
fi

export NODE_TLS_REJECT_UNAUTHORIZED=0
export REMOTE_UPLOAD_DIR=$HOME/www/owncloud-test-middleware/filesForUpload

yarn run watch
