#!/bin/bash
# ------------------
# $1 -- feature path
# ------------------

rm -rf /tmp/ocis
mkdir /tmp/ocis -p

export SERVER_HOST="https://localhost:9200" # where the ui is running
export BACKEND_HOST="https://localhost:9200" # where the api service is running
export OCIS_REVA_DATA_ROOT="/tmp/ocis/owncloud/data"
export TESTING_DATA_DIR="$HOME/www/core/apps/testing/data"
export LOCAL_UPLOAD_DIR="/uploads"
export MIDDLEWARE_HOST="http://localhost:3000"
export WEB_UI_CONFIG="$HOME/www/useful/ocis-config/web-config.json"

cd "$HOME"/www/web/tests/acceptance/ || exit
yarn test:acceptance:ocis features/"$1"
