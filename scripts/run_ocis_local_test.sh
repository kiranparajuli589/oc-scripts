#!/bin/bash

OCIS_ROOT=${OCIS_ROOT:-"$HOME""/go/src/github.com/owncloud/ocis"}

export TEST_OCIS=true
export TEST_WITH_GRAPH_API=true
export SEND_SCENARIO_LINE_REFERENCES=true
export STORAGE_DRIVER=${STORAGE_DRIVER:-"ocis"}
export PATH_TO_CORE=${PATH_TO_CORE:-"$HOME""/www/owncloud/core"}
export TEST_SERVER_URL=${TEST_SERVER_URL:-"https://localhost:9200"}
export SKELETON_DIR=${SKELETON_DIR:-"$HOME""/www/owncloud/core/apps-external/testing/data/apiSkeleton"}
export SSLKEYLOGFILE=${SSLKEYLOGFILE:-"/tmp/sslkey.log"}

while test $# -gt 0; do
	key="$1"
	case ${key} in
	-h | --help)
		echo "======================================"
		echo "Welcome to run ocis local test script ;)"
		echo "======================================"
		echo "Environments:"
		echo "-------------"
		echo "STORAGE_DRIVER   ➡  DEFAULT: 'ocis'"
		echo "PATH_TO_CORE     ➡  DEFAULT: $HOME/www/owncloud/core"
		echo "TEST_SERVER_URL  ➡  DEFAULT: https://localhost:9200"
		echo "OCIS_ROOT        ➡  DEFAULT: $HOME/go/src/github.com/owncloud/ocis"
		echo "SKELETON_DIR     ➡  DEFAULT: $HOME/www/owncloud/core/apps-external/testing/data/apiSkeleton"
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

if [ "$STORAGE_DRIVER" = "owncloud" ]; then
	export OCIS_REVA_DATA_ROOT="/tmp/ocis/owncloud/data/"
	export OCIS_SKELETON_STRATEGY=copy
	export BEHAT_FILTER_TAGS="~@skip&&~@skipOnOcis-OC-Storage"
	export UPLOAD_DELETE_WAIT_TIME=1
else
	export OCIS_SKELETON_STRATEGY=upload
	export BEHAT_FILTER_TAGS="~@skip&&~@skipOnOcis-OCIS-Storage"
	export UPLOAD_DELETE_WAIT_TIME=0
fi

cd "$OCIS_ROOT" || exit
make test-acceptance-api "BEHAT_FEATURE=tests/acceptance/features/""$FEATURE"
