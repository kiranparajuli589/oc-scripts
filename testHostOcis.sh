#!/bin/bash

mkdir /home/kiran/tmp/ocis/storage/users -p
mkdir /home/kiran/tmp/ocis/local/root -p


export OCIS_URL=https://localhost:9200
export STORAGE_HOME_DRIVER=ocis
export STORAGE_USERS_DRIVER=ocis
export STORAGE_DRIVER_OCIS_ROOT=/home/kiran/tmp/ocis/storage/users
export STORAGE_DRIVER_LOCAL_ROOT=/home/kiran/tmp/ocis/local/root
export STORAGE_METADATA_ROOT=/home/kiran/tmp/ocis/metadata
export STORAGE_DRIVER_OWNCLOUD_DATADIR=/home/kiran/tmp/ocis/owncloud/data
export STORAGE_HOME_DATA_SERVER_URL=http://localhost:9155/data
export STORAGE_USERS_DATA_SERVER_URL=http://ocis-server:9158/data
export STORAGE_SHARING_USER_JSON_FILE=/home/kiran/tmp/ocis/shares.json
export PROXY_ENABLE_BASIC_AUTH=True
export WEB_UI_CONFIG=$HOME/www/ocConfigs/ocis-config.json
export IDP_IDENTIFIER_REGISTRATION_CONF=$HOME/www/ocConfigs/idp.yml
export OCIS_LOG_LEVEL=warn
export SETTINGS_DATA_PATH=/home/kiran/tmp/ocis/settings

/home/kiran/go/src/github.com/owncloud/ocis/ocis/bin/ocis server