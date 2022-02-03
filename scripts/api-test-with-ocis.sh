#!/bin/bash

# $1 -> feature path from tests/features/acceptance/

export TEST_SERVER_URL="https://localhost:9200"

export SKELETON_DIR="$HOME/www/core/apps-external/testing/data/apiSkeleton"
export EXPECTED_FAILURES_FILE="$HOME/go/src/github.com/owncloud/ocis/tests/acceptance/expected-failures-API-on-OCIS-storage.md"
export TEST_OCIS="true"
export SEND_SCENARIO_LINE_REFERENCES="true"

if [ "$DRIVER" = 'owncloud' ]
then
	export STORAGE_DRIVER="$DRIVER"
	export OCIS_REVA_DATA_ROOT="$HOME/www/core/data"
	export OCIS_SKELETON_STRATEGY="copy"
	export UPLOAD_DELETE_WAIT_TIME="1"
	export BEHAT_FILTER_TAGS="~@skipOnOcis&&~@notToImplementOnOCIS&&~@toImplementOnOCIS&&~comments-app-required&&~@federation-app-required&&~@notifications-app-required&&~systemtags-app-required&&~@local_storage&&~@skipOnOcis-OC-Storage"
else
	export STORAGE_DRIVER="ocis"
	export OCIS_SKELETON_STRATEGY="upload"
	export UPLOAD_DELETE_WAIT_TIME=0
	export BEHAT_FILTER_TAGS="~@skipOnOcis&&~@notToImplementOnOCIS&&~@toImplementOnOCIS&&~comments-app-required&&~@federation-app-required&&~@notifications-app-required&&~systemtags-app-required&&~@local_storage&&~@skipOnOcis-OCIS-Storage"
fi

export SSLKEYLOGFILE=/tmp/sslkey.log

# assumes owncloud core repo cloned at $HOME/www/core
cd "$HOME"/www/core || exit
make test-acceptance-api BEHAT_FEATURE=tests/acceptance/features/"$1"
