#!/bin/bash

MIDDLEWARE_ROOT="$HOME""/www/owncloud-test-middleware/"

FRESH=False
WITH_OCIS=False

while test $# -gt 0
do
	key="$1"
	case ${key} in
		-f|--fresh)
			FRESH="True"
			;;
		-o|--ocis)
			WITH_OCIS="True"
			;;
		esac
		shift
done

echo $FRESH
echo $WITH_OCIS

# assumes middleware repo cloned under:
cd "$MIDDLEWARE_ROOT" || exit

if [ $FRESH = "True" ]
then
	git stash && git stash clear
	git checkout master
	git pull origin main
	yarn
fi

if [ $WITH_OCIS = "True" ]
then
	export RUN_ON_OCIS=true
	export OCIS_REVA_DATA_ROOT="/tmp/ocis/owncloud/data"
	export BACKEND_HOST=https://localhost:9200
else
	export BACKEND_HOST=http://localhost/core
fi

export NODE_TLS_REJECT_UNAUTHORIZED=0
export REMOTE_UPLOAD_DIR="$MIDDLEWARE_ROOT""filesForUpload"

yarn run watch
