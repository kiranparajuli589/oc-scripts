#!/bin/bash
rm -rf /tmp/ocis/

mkdir /tmp/ocis/storage/users -p
mkdir /tmp/ocis/owncloud/data -p

export ACCOUNTS_DATA_PATH=/tmp/ocis-accounts/
export IDP_IDENTIFIER_REGISTRATION_CONF=/home/kiran/www/ocConfigs/idp.yml
export OCIS_URL=https://localhost:9200
export PROXY_ENABLE_BASIC_AUTH=true
export PROXY_OIDC_INSECURE=true
export STORAGE_DRIVER_LOCAL_ROOT=/tmp/ocis/local/root
export STORAGE_DRIVER_OCIS_ROOT=/tmp/ocis/storage/users
export STORAGE_DRIVER_OWNCLOUD_DATADIR=/tmp/ocis/owncloud/data
export STORAGE_HOME_DATA_SERVER_URL=http://localhost:9155/data
export STORAGE_HOME_DRIVER=ocis
export STORAGE_METADATA_ROOT=/tmp/ocis/metadata
export STORAGE_USERS_DATA_SERVER_URL=http://localhost:9158/data
export STORAGE_USERS_DRIVER=ocis
export WEB_ASSET_PATH=/home/kiran/www/web/dist
export WEB_UI_CONFIG=/home/kiran/www/ocConfigs/ocis-config.json
# export STORAGE_SHARING_USER_JSON_FILE=/tmp/ocis/shares.json


$HOME/go/src/github.com/owncloud/ocis/ocis/bin/ocis server
