#!/bin/bash

PATH_TO_CORE=${PATH_TO_CORE:-"$HOME/www/owncloud/core"}

while test $# -gt 0
do
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
		echo "-f, --feature   ➡  feature to test"
		echo -e "\t\t  a default argument; can be specified without any flag"
		echo -e "\t\t  'tests/acceptance/features/' is already prefixed"
		echo -e "\t\t  you can omit this path and just provide 'suiteName/test.feature'"
		echo ""
		echo "Environments:"
		echo "-------------"
		echo "SELENIUM_PORT        ➡  DEFAULT: 4444"
		echo "PATH_TO_CORE         ➡  DEFAULT: $HOME/www/owncloud/core"
		echo "TEST_SERVER_URL      ➡  DEFAULT: http://localhost/owncloud/core"
		echo "TEST_SERVER_FED_URL  ➡  DEFAULT: http://localhost/owncloud-fed"
		echo ""
		exit 0
		;;
	-t | --type)
		TEST_TYPE="${2,,}"
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

export TEST_SERVER_URL=${TEST_SERVER_URL:-"http://localhost/owncloud/core"}
export TEST_SERVER_FED_URL=${TEST_SERVER_FED_URL:-"http://localhost/owncloud-fed"}
if [ "$1" = 'webui' ]
then
	export SELENIUM_PORT=${SELENIUM_PORT:-4444}
fi

cd "$PATH_TO_CORE" || exit
make test-acceptance-"$TEST_TYPE" \
	BEHAT_FEATURE=tests/acceptance/features/"$FEATURE"
