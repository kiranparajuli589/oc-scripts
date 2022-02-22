#!/bin/bash

# switch to nodejs 16

nvm use 16

MIDDLEWARE_ROOT="$HOME""/www/owncloud-test-middleware"

FRESH=False
WITH_OCIS=False

while test $# -gt 0
do
	key="$1"
	case ${key} in
		-h|--help)
			echo "Welcome to start middleware script ;)"
			echo " "
			echo "Options:"
			echo "-h, --help -> shows brief help about the script"
			echo "-r, --root -> path where the 'owncloud-test-middleware' repository is cloned."
			echo "	(please do not include the last trailing slash)"
			echo "	default: ""$HOME""/go/src/github.com/owncloud/ocis"
			echo "-f, --fresh -> start fresh middleware"
			echo "	checkouts to the latest code, builds and starts the service"
			echo "-o, --ocis -> start middleware with the 'ocis' backend"
			echo " "
			exit 0
			;;
		-r|--root)
			MIDDLEWARE_ROOT=$2
			shift
			;;
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
export REMOTE_UPLOAD_DIR="$MIDDLEWARE_ROOT""/filesForUpload"

yarn run watch
