#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

export TEST_SERVER_URL=${TEST_SERVER_URL:-"http://localhost/owncloud/core"}
export BEHAT_FILTER_TAGS=${BEHAT_FILTER_TAGS:-"~@skip"}
export DOWNLOADS_DIRECTORY=${DOWNLOADS_DIRECTORY:-"/tmp/downloads"}
export SELENIUM_HOST=${SELENIUM_HOST:-"localhost"}
export SELENIUM_PORT=${SELENIUM_PORT:-"4444"}
export BROWSER=${BROWSER:-"chrome"}
export PLATFORM=${PLATFORM:-"Linux"}
export TEST_TYPE=${TEST_TYPE:-"api"}
export MULTIPLE=${MULTIPLE:-1}
export PATH_TO_CORE=${PATH_TO_CORE:-"$HOME/www/owncloud/core"}

MAKE_PARAM="test-acceptance-core-"

while test $# -gt 0; do
	key="$1"
	case ${key} in
	-h | --help)
		echo "=========================================="
		echo "Welcome to run oc10 core tests from app ;)"
		echo "=========================================="
		echo "Options:"
		echo "--------"
		echo "-h, --help      ➡ shows brief help about the script"
		echo "-t, --type      ➡ type of test to run"
		echo -e "\t\t  OPTIONS: 'api', 'cli' or 'webui'"
		echo -e "\t\t  DEFAULT: 'api'"
		echo "-m, --multiple  ➡ number of iteration to run the provided test"
		echo "-f, --feature   ➡ feature to test"
		echo -e "\t\t  a default argument; can be specified without any flag"
		echo -e "\t\t  'tests/acceptance/features/' is already prefixed"
		echo -e "\t\t  you can omit this path and just provide 'suiteName/test.feature'"
		echo ""
		echo "Environments:"
		echo "-------------"
		echo "BEHAT_FILTER_TAGS    ➡  tags to filter tests"
		echo "DOWNLOADS_DIRECTORY  ➡  directory to download files to"
		echo "BROWSER              ➡  browser to run tests in"
		echo "PLATFORM             ➡  platform to run tests on"
		echo "SELENIUM_HOST        ➡  host to run selenium server on"
		echo "SELENIUM_PORT        ➡  DEFAULT: '4444'"
		echo "TEST_TYPE            ➡  DEFAULT: 'api'"
		echo "PATH_TO_CORE         ➡  DEFAULT: $HOME/www/owncloud/core"
		echo "APP_ROOT             ➡ path to the root of the app from the root of 'core'"
		echo "TEST_SERVER_URL      ➡  DEFAULT: http://localhost/owncloud/core"
		echo "TEST_SERVER_FED_URL  ➡  DEFAULT: http://localhost/owncloud/federated"
		echo ""
		exit 0
		;;
	-t | --type)
		TEST_TYPE="${2,,}"
		shift
		;;
	-m | --multiple)
		MULTIPLE="$2"
		shift
		;;
	-f | --feature)
		FEATURE="$2"
		shift
		;;
	*)
		FEATURE="$1"
		;;
	esac
	shift
done

cd "$PATH_TO_CORE" || exit
cd "$APP_ROOT" || exit

if [ -z "$MULTIPLE" ] || [ "$MULTIPLE" -lt 1 ]; then
	MULTIPLE=1
fi

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

declare -A RESULT_ARRAY
for ((i = 1; i <= "$MULTIPLE"; i++)); do
	if make $MAKE_PARAM"$TEST_TYPE" BEHAT_FEATURE=../../tests/acceptance/features/"$FEATURE"; then
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
