#!/bin/bash

export TEST_SERVER_URL=https://localhost:9200
if [ $DRIVER == 'owncloud' ]
then
	export OCIS_REVA_DATA_ROOT=/tmp/ocis/owncloud/data/
	export OCIS_SKELETON_STRATEGY=copy
	export BEHAT_FILTER_TAGS='~@skip&&~@skipOnOcis-OC-Storage'
	export UPLOAD_DELETE_WAIT_TIME=1
else
	export OCIS_SKELETON_STRATEGY=upload
	export BEHAT_FILTER_TAGS='~@skip&&~@skipOnOcis-OCIS-Storage'
	export UPLOAD_DELETE_WAIT_TIME=0
fi
export SKELETON_DIR=$HOME/www/core/apps-external/testing/data/apiSkeleton
export TEST_OCIS=true
export SEND_SCENARIO_LINE_REFERENCES=true
export STORAGE_DRIVER=$DRIVER
export PATH_TO_CORE=$HOME/www/core

cd $HOME/go/src/github.com/owncloud/ocis/
make test-acceptance-api BEHAT_FEATURE=$1
