#!/bin/bash

export TEST_SERVER_URL=https://localhost:9200
#export OCIS_REVA_DATA_ROOT=""
export OCIS_REVA_DATA_ROOT="/tmp/ocis/owncloud/data/"
export SKELETON_DIR=$HOME/www/core/apps-external/testing/data/apiSkeleton
#export OCIS_SKELETON_STRATEGY="upload"
export OCIS_SKELETON_STRATEGY="copy"
export TEST_OCIS=true
#export STORAGE_DRIVER=ocis
export STORAGE_DRIVER=owncloud
export PATH_TO_CORE=$HOME/www/core
export BEHAT_FEATURE=$BEHAT_FEATURE
export BEHAT_FILTER_TAGS="~@skipOnOcis-OC"
#export BEHAT_FILTER_TAGS="~@skipOnOcis-OCIS"

cd $PATH_TO_CORE
make test-acceptance-api 
