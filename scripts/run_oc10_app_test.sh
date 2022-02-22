#!/bin/bash

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
		echo "TEST_SERVER_URL ➡  DEFAULT: http://localhost/core"
		echo "APP_ROOT        ➡  path to the server app repository"
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

export TEST_SERVER_URL=${TEST_SERVER_URL:-"http://localhost/core"}

cd "$APP_ROOT" || exit

if [ -z "$MULTIPLE" ] || [ "$MULTIPLE" -lt 1 ]; then
	MULTIPLE=1
fi

for ((i = 1; i <= "$MULTIPLE"; i++)); do
	if make test-acceptance-"$TEST_TYPE" BEHAT_FEATURE="$BEHAT_FEATURE"; then
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
