#!/bin/bash
export OCIS_URL="https://localhost:9200"
export PROXY_ENABLE_BASIC_AUTH=True
export WEB_UI_CONFIG="$HOME/www/useful/ocis-config/web-config.json"
export WEB_ASSET_PATH="$HOME/www/web/dist/"
export IDP_IDENTIFIER_REGISTRATION_CONF="$HOME/www/useful/ocis-config/idp.yml"
export OCIS_LOG_LEVEL="error"
export OCIS_INSECURE="true"

# assumes ocis repo cloned at
OCIS_ROOT="$HOME""/go/src/github.com/owncloud/ocis/"

while test $# -gt 0
do
	key="$1"
	case ${key} in
		-f|--fresh)
			FRESH=True
			shift
			;;
		esac
		shift
done

if [ "$FRESH" = "True" ]
then
	cd "$OCIS_ROOT" || exit
	make clean
	make generate
	cd "$OCIS_ROOT""ocis" || exit
	make build
fi

if [ "$DRIVER" = 'owncloud' ]
then
	export STORAGE_HOME_DRIVER="owncloud"
	export STORAGE_USERS_DRIVER="owncloud"
else
	export STORAGE_HOME_DRIVER="ocis"
	export STORAGE_USERS_DRIVER="ocis"
fi

"$OCIS_ROOT""ocis/bin/ocis" server
