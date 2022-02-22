#!/bin/bash

export OCIS_INSECURE="true"
export OCIS_LOG_LEVEL="error"
export PROXY_ENABLE_BASIC_AUTH=True
export OCIS_URL="https://localhost:9200"
export WEB_ASSET_PATH="$HOME/www/web/dist/"
export WEB_UI_CONFIG="$HOME/www/useful/ocis-config/web-config.json"
export IDP_IDENTIFIER_REGISTRATION_CONF="$HOME/www/useful/ocis-config/idp.yml"

OCIS_ROOT=${OCIS_ROOT:-"$HOME""/go/src/github.com/owncloud/ocis"}
STORAGE_DRIVER=${STORAGE_DRIVER:-"ocis"}

while test $# -gt 0
do
	key="$1"
	case ${key} in
		-h|--help)
			echo "==============================="
			echo "Welcome to start ocis script ;)"
			echo "==============================="
			echo "Start ocis server at https://localhost:9200"
			echo ""
			echo "Options:"
			echo "--------"
			echo "-h, --help   ➡  shows brief help about the script"
			echo "-f, --fresh  ➡  start 'ocis' server with fresh code"
			echo ""
			echo "Environments:"
			echo "-------------"
			echo "STORAGE_DRIVER  ➡  storage driver to use for the server"
			echo -e "\t\t   DEFAULT: 'ocis'"
			echo -e "\t\t   OPTIONS: 'ocis' & 'owncloud'"
			echo "OCIS_ROOT       ➡  path where the 'owncloud-test-middleware' repository is cloned"
			echo -e "\t\t   DEFAULT: $HOME/go/src/github.com/owncloud/ocis"
			echo -e "\t\t   CAUTION: please do not include the last trailing slash"
			echo ""
			exit 0
			;;
		-f|--fresh)
			cd "$OCIS_ROOT" || exit
			git stash && git stash clear
			git checkout master
			git pull origin master
			make clean
			make generate
			cd "$OCIS_ROOT""/ocis" || exit
			make build
			shift
			;;
		esac
		shift
done

export STORAGE_HOME_DRIVER=$STORAGE_DRIVER
export STORAGE_USERS_DRIVER=$STORAGE_DRIVER

"$OCIS_ROOT""/ocis/bin/ocis" server
