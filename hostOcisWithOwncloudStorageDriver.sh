export OCIS_URL='https://localhost:9200' \
export STORAGE_HOME_DRIVER='owncloud' \
export STORAGE_USERS_DRIVER='owncloud' \
export STORAGE_DRIVER_OCIS_ROOT='/tmp/ocis/storage/users' \
export STORAGE_DRIVER_LOCAL_ROOT='/tmp/ocis/local/root' \
export STORAGE_DRIVER_OWNCLOUD_DATADIR='/tmp/ocis/owncloud/data' \
export STORAGE_METADATA_ROOT='/tmp/ocis/metadata' \
export STORAGE_HOME_DATA_SERVER_URL='http://localhost:9155/data' \
export STORAGE_USERS_DATA_SERVER_URL='http://localhost:9158/data' \
export WEB_UI_CONFIG=$HOME/www/ocConfigs/ocis-config.json \
export WEB_ASSET_PATH=$HOME/www/web/dist \
export IDP_IDENTIFIER_REGISTRATION_CONF=$HOME/www/ocConfigs/idp.yml \
export PROXY_ENABLE_BASIC_AUTH=True \
export OCIS_LOG_LEVEL='warn' \
export ACCOUNTS_DATA_PATH="/tmp/ocis-accounts/" \
export SETTINGS_DATA_PATH="/tmp/ocis/settings" \
export STORAGE_SHARING_USER_JSON_FILE="/tmp/ocis/shares.json" \
export STORAGE_DRIVER_OWNCLOUD_REDIS_ADDR='localhost:6379'

$HOME/go/src/github.com/owncloud/ocis/ocis/bin/ocis server
