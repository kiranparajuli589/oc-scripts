#!/bin/bash

WITH_OCIS=false
WEB_ROOT=${WEB_ROOT:-"$HOME""/www/web"}

while test $# -gt 0; do
	key="$1"
	case ${key} in
	-h | --help)
		echo "====================================="
		echo "Welcome to run web e2e test script ;)"
		echo "====================================="
		echo "Options:"
		echo "--------"
		echo "-h, --help     ➡  shows brief help about the script"
		echo "-o, --ocis     ➡  run test with ocis backend"
		echo -e "\t\t  DEFAULT: false; defaults to oc10 backend"
		echo "-m, --multiple ➡  number of iteration to run the provided test"
		echo -e "\t\t  DEFAULT: 1"
		echo "-f, --feature  ➡  feature to test"
		echo -e "\t\t  a default argument; can be specified without any flag"
		echo -e "\t\t  'tests/e2e/cucumber/' is already prefixed"
		echo -e "\t\t  you can omit this path and just provide the feature file name!"
		echo ""
		echo "Environments:"
		echo "-------------"
		echo "WEB_ROOT         ➡  path where 'web' repository is cloned"
		echo -e "\t\t  DEFAULT: $HOME/www/web"
		echo "BASE_URL_OCIS    ➡  only required while running with ocis backend"
		echo -e "\t\t  DEFAULT: localhost:9200"
		echo "BACKEND_HOST     ➡  only required while running with oc10 backend"
		echo -e "\t\t  DEFAULT: http://localhost/owncloud/core"
		echo "SERVER_HOST      ➡  only required while running with oc10 backend"
		echo -e "\t\t  DEFAULT: http://localhost/web/dist"
		exit 0
		;;
	-o | --ocis)
		WITH_OCIS=true
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
		export FEATURE="$1"
		;;
	esac
	shift
done

if [ "$WITH_OCIS" = true ]; then
	export OCIS=true
	export BASE_URL_OCIS=${BASE_URL_OCIS:-"localhost:9200"}
else
	export BACKEND_HOST=${BACKEND_HOST:-"http://localhost/owncloud/core"}
	# do not use web integration app but the web itself
	export SERVER_HOST=${SERVER_HOST:-"http://localhost/web/dist"}
fi

cd "$WEB_ROOT" || exit

if [ -z "$MULTIPLE" ] || [ "$MULTIPLE" -lt 1 ]; then
	MULTIPLE=1
fi

declare -A RESULT_ARRAY

for ((i = 1; i <= "$MULTIPLE"; i++)); do
	if yarn test:e2e:cucumber tests/e2e/cucumber/"${FEATURE}"; then
		RESULT_ARRAY[$i]=0
	else
		RESULT_ARRAY[$i]=1
	fi
done


echo "Test Summary:"
echo "________________________________"

for i in "${!RESULT_ARRAY[@]}"
do
	STATUS=$( [ ${RESULT_ARRAY[$i]} == 0 ] && echo "Passed (0)" || echo "Failed (1)" )
	echo -e "Iteration: ""$i""\tStatus: ""$STATUS"
done
