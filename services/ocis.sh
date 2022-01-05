#!/bin/bash
rm -rf /tmp/ocis/
mkdir /tmp/ocis -p

export OCIS_URL="https://localhost:9200"
export STORAGE_USERS_DRIVER_LOCAL_ROOT="/tmp/ocis/local/root"
export STORAGE_USERS_DRIVER_OWNCLOUD_DATADIR="/tmp/ocis/owncloud/data"
export STORAGE_USERS_DRIVER_OCIS_ROOT="/tmp/ocis/storage/users"
export STORAGE_METADATA_DRIVER_OCIS_ROOT="/tmp/ocis/storage/metadata"
export STORAGE_SHARING_USER_JSON_FILE="/tmp/ocis/shares.json"
export PROXY_ENABLE_BASIC_AUTH=True
export WEB_UI_CONFIG="/$HOME/www/useful/ocis-config/web-config.json"
export IDP_IDENTIFIER_REGISTRATION_CONF="/$HOME/www/useful/ocis-config/idp.yml"
export OCIS_LOG_LEVEL="error"
export SETTINGS_DATA_PATH="/tmp/ocis/settings"
export OCIS_INSECURE="true"

if [ "$DRIVER" = 'owncloud' ]
then
	export STORAGE_HOME_DRIVER="owncloud"
	export STORAGE_USERS_DRIVER="owncloud"
else
	export STORAGE_HOME_DRIVER="ocis"
	export STORAGE_USERS_DRIVER="ocis"
fi

"$HOME"/go/src/github.com/owncloud/ocis/ocis/bin/ocis server
