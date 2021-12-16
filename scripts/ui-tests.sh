#!/bin/bash

rm -rf /tmp/ocis
mkdir /tmp/ocis -p

export SERVER_HOST=https://localhost:9200
export BACKEND_HOST=https://localhost:9200
export RUN_ON_OCIS=True
export OCIS_REVA_DATA_ROOT=/tmp/ocis/owncloud/data
export TESTING_DATA_DIR=$HOME/www/core/apps-external/testing/data
export WEB_UI_CONFIG=$HOME/www/oc-configs/ocis-config/web-config.json
export TEST_TAGS="not @skipOnOCIS and not @skip and not @notToImplementOnOCIS and not @federated-server-needed"
export LOCAL_UPLOAD_DIR=/uploads
export NODE_TLS_REJECT_UNAUTHORIZED=0

cd "$HOME"/www/web || exit
bash -x ./tests/acceptance/run.sh
