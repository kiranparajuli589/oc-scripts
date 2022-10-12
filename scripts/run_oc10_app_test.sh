#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
TEST_TYPE=${TEST_TYPE:-"api"}
CORE_PATH=${CORE_PATH:-"$HOME/www/owncloud/core"}
LOCAL_MAILHOG_HOST=${LOCAL_MAILHOG_HOST:-"host.docker.internal"}
MAILHOG_PORT=${MAILHOG_PORT:-"8025"}

while test $# -gt 0; do
	key="$1"
	case ${key} in
	-h | --help)
		echo "======================================"
		echo "Welcome to run oc10 app test script ;)"
		echo "======================================"
		echo "Options:"
		echo "--------"
		echo "-h, --help      ➡  shows brief help about the script"
		echo "-t, --type      ➡  type of test to run; can be 'api', 'cli' or 'webui' (required)"
		echo "-m, --multiple  ➡  number of iteration to run the provided test; defaults to 1"
		echo "-f, --feature   ➡  feature to test; default argument; can be specified without any flag"
		echo ""
		echo "Environments:"
		echo "-------------"
		echo "TEST_SERVER_URL     ➡  DEFAULT: http://host.docker.internal/owncloud/core"
		echo "APP_ROOT            ➡  path to the server app repository"
		echo "LOCAL_MAILHOG_HOST  ➡  DEFAULT: http://host.docker.internal/owncloud/core"
		echo "MAILHOG_ROOT        ➡  path to the server app repository"
		echo ""
		exit 0
		;;
	-m | --multiple)
		MULTIPLE="$2"
		shift
		;;
	-t | --type)
		TEST_TYPE="${2,,}"
		shift
		;;
	-f | --feature)
		BEHAT_FEATURE="$2"
		shift
		;;
	*)
		BEHAT_FEATURE="$1"
		;;
	esac
	shift
done

export TEST_SERVER_URL=${TEST_SERVER_URL:-"http://host.docker.internal/owncloud/core"}

if [ "$TEST_TYPE" = 'webui' ]; then
	export SELENIUM_PORT=${SELENIUM_PORT:-4444}
	if wait-for-it "localhost:""$SELENIUM_PORT" --timeout=5; then
		echo "Cheers! the 'selenium' server is running at port '4444'"
	else
		echo "Hmm...looks like you forget to start the 'selenium' server"
		echo "Don't worry :) We're starting it for you!"
		bash -x "$SCRIPT_DIR"/../services/core_selenium.sh
		wait-for-it localhost:4444 --timeout=5
		export SELENIUM_PORT=4444
		echo "Boom! the 'selenium' server is now up at PORT '4444'"
	fi
fi

cd "$CORE_PATH" || exit
cd "$APP_ROOT" || exit

if [ -z "$MULTIPLE" ] || [ "$MULTIPLE" -lt 1 ]; then
	MULTIPLE=1
fi

for ((i = 1; i <= "$MULTIPLE"; i++)); do
	if make test-acceptance-"$TEST_TYPE" BEHAT_FEATURE=tests/acceptance/features/"$BEHAT_FEATURE"; then
		RESULT_ARRAY[$i]=0
	else
		RESULT_ARRAY[$i]=1
	fi
done

echo "Test Summary:"
echo "________________________________"

for i in "${!RESULT_ARRAY[@]}"; do
	STATUS=$([ ${RESULT_ARRAY[$i]} == 0 ] && echo "Passed (0)" || echo "Failed (1)")
	echo -e "Iteration: ""$i""\tStatus: ""$STATUS"
done
