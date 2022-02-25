#!/bin/bash

MIDDLEWARE_ROOT=${MIDDLEWARE_ROOT:-"$HOME""/www/owncloud-test-middleware"}

WITH_OCIS=False

while test $# -gt 0
do
	key="$1"
	case ${key} in
		-h|--help)
			echo "====================================="
			echo "Welcome to start middleware script ;)"
			echo "====================================="
			echo "Options:"
			echo "--------"
			echo "-h, --help  ➡  shows brief help about the script"
			echo "-o, --ocis  ➡  start middleware with the 'ocis' backend"
			echo "-f, --fresh ➡  start fresh middleware"
			echo -e "\t       checkouts to the latest code, builds and starts the service"
			echo ""
			echo "Environments:"
			echo "-------------"
			echo "MIDDLEWARE_ROOT  ➡  path where the 'owncloud-test-middleware' repository is cloned"
			echo -e "\t\t    please do not include the last trailing slash"
			echo -e "\t\t    default: $HOME/www/owncloud-test-middleware"
			echo "BACKEND_HOST     ➡  server host url"
			echo -e "\t\t    DEFAULT:"
			echo -e "\t\t      - while testing with 'oc10' backend: http://localhost/owncloud/core"
			echo -e "\t\t      - while testing with 'ocis' backend: https://localhost/9200"
			echo ""
			exit 0
			;;
		-f|--fresh)
			cd "$MIDDLEWARE_ROOT" || exit
			git stash && git stash clear
			git checkout main
			git pull origin main
			yarn
			;;
		-o|--ocis)
			WITH_OCIS="True"
			;;
		esac
		shift
done

cd "$MIDDLEWARE_ROOT" || exit

if [ $WITH_OCIS = "True" ]
then
	export RUN_ON_OCIS=true
	export OCIS_REVA_DATA_ROOT="/tmp/ocis/owncloud/data"
	export BACKEND_HOST=${BACKEND_HOST:-"https://localhost:9200"}
else
	export BACKEND_HOST=${BACKEND_HOST:-"http://localhost/owncloud/core"}
fi

export NODE_TLS_REJECT_UNAUTHORIZED=0
export REMOTE_UPLOAD_DIR="$MIDDLEWARE_ROOT""/filesForUpload"

yarn run watch
