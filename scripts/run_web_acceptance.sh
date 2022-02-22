#!/bin/bash

# wait for selenium to be up
if wait-for-it localhost:4444 --timeout=5
then
	echo "Selenium is running at port 4444"
else
	echo "Hmm...looks like you forget to start selenium server."
	bash -x "$HOME"/www/useful/services/web_selenium.sh
	wait-for-it localhost:4444 --timeout=5
fi

while test $# -gt 0; do
	key="$1"
	case ${key} in
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


export MIDDLEWARE_HOST="http://localhost:3000"
export REMOTE_UPLOAD_DIR=$HOME/www/owncloud-test-middleware/filesForUpload/

if [ $WITH_OCIS = "True" ]; then
	rm -rf /tmp/ocis
	mkdir /tmp/ocis -p

	export SERVER_HOST="https://localhost:9200"  # where the ui is running
	export BACKEND_HOST="https://localhost:9200" # where the api service is running
	export OCIS_REVA_DATA_ROOT="/tmp/ocis/owncloud/data"
	export TESTING_DATA_DIR="$HOME/www/core/apps/testing/data"
	export LOCAL_UPLOAD_DIR="/uploads"
	export WEB_UI_CONFIG="$HOME/www/useful/ocis-config/web-config.json"
else
	export SERVER_HOST=http://localhost/web/dist
	export BACKEND_HOST=http://localhost/core
	export REMOTE_BACKEND_HOST=http://localhost/owncloud-fed
	export MIDDLEWARE_HOST="http://localhost:3000"
fi

cd "$HOME"/www/web/tests/acceptance || exit

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
