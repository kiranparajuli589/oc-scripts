#!/bin/bash

export PATH_TO_CORE=${PATH_TO_CORE:-"$HOME""/www/owncloud/core"}
export PATH_TO_OCIS=${PATH_TO_OCIS:-"$HOME""/go/src/github.com/owncloud/ocis"}
export PATH_TO_WEB=${PATH_TO_WEB:-"$HOME""/www/owncloud/web"}

while test $# -gt 0; do
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
		echo "PATH_TO_OCIS     ➡  DEFAULT: $HOME/go/src/github.com/owncloud/ocis"
		echo "PATH_TO_WEB      ➡  DEFAULT: $HOME/www/owncloud/web"
		echo "STORAGE_DRIVER   ➡  DEFAULT: 'ocis'"
		echo "SSLKEYLOGFILE    ➡  DEFAULT: /tmp/sslkey.log"
		echo "TEST_SERVER_URL  ➡  DEFAULT: https://host.docker.internal:9200"
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
export TEST_WITH_GRAPH_API=${TEST_WITH_GRAPH_API:-true}
export SEND_SCENARIO_LINE_REFERENCES="true"
export STORAGE_DRIVER=${STORAGE_DRIVER:-"ocis"}
export SSLKEYLOGFILE=${SSLKEYLOGFILE:-"/tmp/sslkey.log"}
export TEST_SERVER_URL=${TEST_SERVER_URL:-"https://host.docker.internal:9200"}
export SKELETON_DIR=${SKELETON_DIR:-"$HOME/www/owncloud/core/apps-external/testing/data/apiSkeleton/"}

export EXPECTED_FAILURES_FILE="$PATH_TO_OCIS/tests/acceptance/expected-failures-API-on-OCIS-storage.md"

if [ "$STORAGE_DRIVER" = 'owncloud' ]; then
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
