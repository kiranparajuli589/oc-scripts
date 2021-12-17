#!/bin/bash
# ------------------
# $1 -- feature path
# ------------------

rm -rf /tmp/ocis
mkdir /tmp/ocis -p

export SERVER_HOST="https://localhost:9200"
export BACKEND_HOST="https://localhost:9200"
export OCIS_REVA_DATA_ROOT="/tmp/ocis/owncloud/data"
export TESTING_DATA_DIR="/$HOME/www/core/apps/testing/data"
export WEB_UI_CONFIG="/$HOME/www/useful/ocis-config/ocis-config.json"
export LOCAL_UPLOAD_DIR="/uploads"
export MIDDLEWARE_HOST="http://localhost:3000"

cd "$HOME"/www/web/tests/acceptance/ || exit
yarn test:acceptance:ocis "$1"
