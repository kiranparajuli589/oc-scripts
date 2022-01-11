#!/bin/bash
export OCIS_URL="https://localhost:9200"
export PROXY_ENABLE_BASIC_AUTH=True
export WEB_UI_CONFIG="/$HOME/www/useful/ocis-config/web-config.json"
export WEB_ASSET_PATH="$HOME/www/web/dist/"
export IDP_IDENTIFIER_REGISTRATION_CONF="/$HOME/www/useful/ocis-config/idp.yml"
export OCIS_LOG_LEVEL="error"
export OCIS_INSECURE="true"

if [ "$DRIVER" = 'owncloud' ]
then
	export STORAGE_HOME_DRIVER="owncloud"
	export STORAGE_USERS_DRIVER="owncloud"
else
	export STORAGE_HOME_DRIVER="ocis"
	export STORAGE_USERS_DRIVER="ocis"
fi

# assumes ocis repo cloned at"$HOME"/go/src/github.com/owncloud/ocis
"$HOME"/go/src/github.com/owncloud/ocis/ocis/bin/ocis server
