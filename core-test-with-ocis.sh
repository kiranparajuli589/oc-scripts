#!/bin/bash

export TEST_SERVER_URL=https://ocis-server:9200
export SKELETON_DIR=$HOME/www/core/apps-external/testing/data/apiSkeleton
export TEST_OCIS=true
export STORAGE_DRIVER=$DRIVER
if [ $DRIVER == 'owncloud'];
then
	export OCIS_REVA_DATA_ROOT=/srv/app/tmp/ocis/owncloud/data/
	export OCIS_SKELETON_STRATEGY=copy
	export BEHAT_FILTER_TAGS=~@skipOnOcis&&~@notToImplementOnOCIS&&~@toImplementOnOCIS&&~comments-app-required&&~@federation-app-required&&~@notifications-app-required&&~systemtags-app-required&&~@local_storage&&~@skipOnOcis-owncloud-Storage
	export EXPECTED_FAILURES_FILE=$HOME/www/core/tests/acceptance/expected-failures-API-on-OWNCLOUD-storage.md
else
	export OCIS_REVA_DATA_ROOT=
	export OCIS_SKELETON_STRATEGY=upload
	export BEHAT_FILTER_TAGS=~@skipOnOcis&&~@notToImplementOnOCIS&&~@toImplementOnOCIS&&~comments-app-required&&~@federation-app-required&&~@notifications-app-required&&~systemtags-app-required&&~@local_storage&&~@skipOnOcis-OCIS-Storage
	export EXPECTED_FAILURES_FILE=$HOME/www/core/tests/acceptance/expected-failures-API-on-OCIS-storage.md
cd $HOME/www/core
make test-acceptance-api