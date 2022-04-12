#!/bin/bash

PATH_TO_CORE=${PATH_TO_CORE:-"$HOME""/www/owncloud/core"}
OCIS_ROOT=${OCIS_ROOT:-"$HOME""/go/src/github.com/owncloud/ocis"}

while test $# -gt 0
do
	key="$1"
	case ${key} in
	-h | --help)
		echo "========================================"
		echo "Welcome to run ocis local test script ;)"
		echo "========================================"
		echo "Options:"
		echo "--------"
		echo "-h, --help       ➡  shows brief help about the script"
		echo "-f, --feature    ➡  feature to test"
		echo -e "\t\t  a default argument; can be specified without any flag"
		echo -e "\t\t  'tests/acceptance/features/' is already prefixed"
		echo -e "\t\t  you can omit this path and just provide 'suiteName/test.feature'"
		echo ""
		echo "Environments:"
		echo "-------------"
		echo "PATH_TO_CORE     ➡  DEFAULT: $HOME/www/owncloud/core"
		echo "OCIS_ROOT        ➡  DEFAULT: $HOME/go/src/github.com/owncloud/ocis"
		echo "STORAGE_DRIVER   ➡  DEFAULT: 'ocis'"
		echo "SSLKEYLOGFILE    ➡  DEFAULT: /tmp/sslkey.log"
		echo "TEST_SERVER_URL  ➡  DEFAULT: https://localhost:9200"
		echo "SKELETON_DIR     ➡  DEFAULT: $HOME/www/owncloud/core/apps-external/testing/data/apiSkeleton/"
		echo ""
		exit 0
		;;
	-f | --feature)
		FEATURE="$2"
		shift
		;;
	*)
		export FEATURE="$1"
		;;
	esac
	shift
done


export TEST_OCIS="true"
export SEND_SCENARIO_LINE_REFERENCES="true"
export STORAGE_DRIVER=${STORAGE_DRIVER:-"ocis"}
export SSLKEYLOGFILE=${SSLKEYLOGFILE:-"/tmp/sslkey.log"}
export TEST_SERVER_URL=${TEST_SERVER_URL:-"https://localhost:9200"}
export SKELETON_DIR=${SKELETON_DIR:-"$HOME/www/owncloud/core/apps-external/testing/data/apiSkeleton/"}

# for tests running with graph api flag enabled
export EXPECTED_FAILURES_FILE="$OCIS_ROOT/tests/acceptance/expected-failures-graphAPI-on-OCIS-storage.md"

if [ "$STORAGE_DRIVER" = 'owncloud' ]
then
	export OCIS_REVA_DATA_ROOT="$PATH_TO_CORE""/data"
	export OCIS_SKELETON_STRATEGY="copy"
	export UPLOAD_DELETE_WAIT_TIME="1"
	export BEHAT_FILTER_TAGS="~@skipOnOcis&&~@notToImplementOnOCIS&&~@toImplementOnOCIS&&~comments-app-required&&~@federation-app-required&&~@notifications-app-required&&~systemtags-app-required&&~@local_storage&&~@skipOnOcis-OC-Storage"
else
	export OCIS_SKELETON_STRATEGY="upload"
	export UPLOAD_DELETE_WAIT_TIME=0
	export BEHAT_FILTER_TAGS="~@skipOnOcis&&~@notToImplementOnOCIS&&~@toImplementOnOCIS&&~comments-app-required&&~@federation-app-required&&~@notifications-app-required&&~systemtags-app-required&&~@local_storage&&~@skipOnOcis-OCIS-Storage"
fi


cd "$PATH_TO_CORE" || exit

make test-acceptance-api \
	BEHAT_FEATURE="tests/acceptance/features/""$FEATURE"
