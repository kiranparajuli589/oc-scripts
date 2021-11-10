#!/bin/bash

export SERVER_HOST="https://localhost:9200"
export BACKEND_HOST="https://localhost:9200"
export OCIS_REVA_DATA_ROOT="/tmp/ocis/owncloud/data"
export TESTING_DATA_DIR="/tmp/testing/data"
export WEB_UI_CONFIG="$HOME/www/ocConfigs/ocis-config/ocis-config.json"
export LOCAL_UPLOAD_DIR="/uploads"

cd $HOME/www/web/tests/acceptance
echo $MULTIPLE

if [ -z ${MULTIPLE} ]
then
	echo "Running test for single time"
	MULTIPLE=1
else
	echo "Running test for multiple times"
fi

for (( i=1; i<=$MULTIPLE; i++ ))
do
	yarn run test:acceptance:ocis "$1"
done
