#!/bin/bash

export WITH_OCIS=false
export WEB_ROOT=${WEB_ROOT:-"$HOME""/www/owncloud/web"}
export SSLKEYLOGFILE=${SSLKEYLOGFILE:-"/tmp/sslkey.log"}

while test $# -gt 0
do
	key="$1"
	case ${key} in
	-h|--help)
		echo "============================================"
		echo "Welcome to run web acceptance test script ;)"
		echo "============================================"
		echo "Options:"
		echo "--------"
		echo "-h, --help     ➡  shows brief help about the script"
		echo "-o, --ocis     ➡  run test with ocis backend"
		echo -e "\t\t  DEFAULT: false; defaults to oc10 backend"
		echo "-m, --multiple ➡  number of iteration to run the provided test"
		echo "-f, --feature  ➡  feature to test"
		echo -e "\t\t  a default argument; can be specified without any flag"
		echo -e "\t\t  'features/' is already prefixed"
		echo -e "\t\t  you can omit this path and just provide 'suiteName/test.feature'"
		echo ""
		echo "Environments:"
		echo "-------------"
		echo "WEB_ROOT             ➡  path where 'web' repository is cloned"
		echo -e "\t\t\tDEFAULT: $HOME/owncloud/web"
		echo -e "\t\t\tCAUTION: please do not include the trailing slash"
		echo "SELENIUM_SERVER      ➡  selenium server url"
		echo -e "\t\t\tDEFAULT: host.docker.internal:4444"
		echo "MIDDLEWARE_HOST      ➡  middleware host url"
		echo -e "\t\t\tDEFAULT: http://host.docker.internal:3000"
		echo "REMOTE_UPLOAD_DIR    ➡  path to remote upload directory"
		echo -e "\t\t\tDEFAULT: $HOME/www/owncloud/middleware/filesForUpload/"
		echo "SERVER_HOST          ➡  webUI host url"
		echo -e "\t\t\tDEFAULT:"
		echo -e "\t\t\t  - while testing with oc10 backend: http://host.docker.internal/owncloud/web/dist"
		echo -e "\t\t\t  - while testing with ocis backend: https://host.docker.internal/9200"
		echo "BACKEND_HOST         ➡  server host url"
		echo -e "\t\t\tDEFAULT:"
		echo -e "\t\t\t  - while testing with oc10 backend: http://host.docker.internal/owncloud/core"
		echo -e "\t\t\t  - while testing with ocis backend: https://host.docker.internal/9200"
		echo "REMOTE_BACKEND_HOST  ➡  remote backend host url (only set while running with oc10 backend for now)"
    		echo -e "\t\t\tDEFAULT: http://host.docker.internal/owncloud/federated"
		echo "TESTING_DATA_DIR     ➡  path to the 'testing' data directory"
		echo -e "\t\t\tDEFAULT: $HOME/www/owncloud/core/apps/testing/data"
		echo ""
		exit 0
		;;
	-o | --ocis)
		WITH_OCIS=True
		;;
	-m|--multiple)
		MULTIPLE="$2"
		shift
		;;
	-f | --feature)
		FEATURE=$2
		;;
	*)
		FEATURE="$1"
		;;
	esac
	shift
done

# check if selenium server is available
SELENIUM_SERVER=${SELENIUM_SERVER:-"host.docker.internal:4444"}

if wait-for-it "$SELENIUM_SERVER" --timeout=5
then
	echo "Cheers! the 'selenium' server is running at port '4444'"
else
	echo "Hmm...looks like you forget to start the 'selenium' server"
	echo "Don't worry :) We're starting it for you!"
	bash -x "$HOME"/www/useful/services/web_selenium.sh
	wait-for-it host.docker.internal:4444 --timeout=5
	echo "Boom! the 'selenium' server is now up at PORT '4444'"
fi

export MIDDLEWARE_HOST=${MIDDLEWARE_HOST:-"http://host.docker.internal:3000"}
export REMOTE_UPLOAD_DIR=${REMOTE_UPLOAD_DIR:-"$HOME""/www/owncloud/middleware/filesForUpload/"}

if [ $WITH_OCIS = "True" ]; then
	rm -rf /tmp/ocis
	mkdir /tmp/ocis -p

	export SERVER_HOST=${SERVER_HOST:-"https://host.docker.internal:9200"}  # where the ui is running
	export BACKEND_HOST=${BACKEND_HOST:-"https://host.docker.internal:9200"} # where the api service is running
	export OCIS_REVA_DATA_ROOT="/tmp/ocis/owncloud/data"
	export TESTING_DATA_DIR=${TESTING_DATA_DIR:-"$HOME/www/owncloud/core/apps/testing/data"}
	export LOCAL_UPLOAD_DIR="/uploads"
	export WEB_UI_CONFIG="$HOME/www/useful/ocis-config/web-config.json"
else
	export SERVER_HOST=${SERVER_HOST:-"http://host.docker.internal/owncloud/web/dist"}
	export BACKEND_HOST=${BACKEND_HOST:-"http://host.docker.internal/owncloud/core"}
	export REMOTE_BACKEND_HOST=${REMOTE_BACKEND_HOST:-"http://host.docker.internal/owncloud/federated"}
fi

cd "$WEB_ROOT""/tests/acceptance" || exit

if [ -z "$MULTIPLE" ] || [ "$MULTIPLE" -lt 1 ]
then
	MULTIPLE=1
fi

declare -A RESULT_ARRAY

for (( i=1; i<="$MULTIPLE"; i++ ))
do
	case "$WITH_OCIS" in
		True) SCRIPT="test:acceptance:ocis" ;;
		*) SCRIPT="test:acceptance:oc10" ;;
	esac
	if yarn "$SCRIPT" features/"$FEATURE"
	then
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
