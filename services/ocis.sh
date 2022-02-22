#!/bin/bash

export OCIS_INSECURE="true"
export OCIS_LOG_LEVEL="error"
export PROXY_ENABLE_BASIC_AUTH=True
export OCIS_URL="https://localhost:9200"
export WEB_ASSET_PATH="$HOME/www/web/dist/"
export WEB_UI_CONFIG="$HOME/www/useful/ocis-config/web-config.json"
export IDP_IDENTIFIER_REGISTRATION_CONF="$HOME/www/useful/ocis-config/idp.yml"

OCIS_ROOT="$HOME""/go/src/github.com/owncloud/ocis"

while test $# -gt 0
do
	key="$1"
	case ${key} in
		-h|--help)
			echo "Welcome to start ocis script ;)"
			echo " "
			echo "Options:"
			echo "-h, --help -> shows brief help about the script"
			echo "-r, --root -> path where the 'ocis' repository is cloned."
			echo "	(please do not include the last trailing slash)"
			echo "	default: ""$HOME""/go/src/github.com/owncloud/ocis"
			echo "-d, --driver -> driver to use"
			echo "	default: 'ocis'; can be: 'owncloud' or 'ocis'"
			echo " "
			exit 0
			;;
		-r|--root)
			OCIS_ROOT=$2
			shift
			;;
		-f|--fresh)
			FRESH=True
			shift
			;;
		-d|--driver)
			DRIVER=$2
			shift
			;;
		esac
		shift
done

if [ "$FRESH" = "True" ]
then
	cd "$OCIS_ROOT" || exit
	git stash && git stash clear
	git checkout master
	git pull origin master
	make clean
	make generate
	cd "$OCIS_ROOT""/ocis" || exit
	make build
fi

if [ "$DRIVER" = 'owncloud' ]
then
	export STORAGE_HOME_DRIVER=$DRIVER
	export STORAGE_USERS_DRIVER=$DRIVER
else
	export STORAGE_HOME_DRIVER="ocis"
	export STORAGE_USERS_DRIVER="ocis"
fi

"$OCIS_ROOT""/ocis/bin/ocis" server
