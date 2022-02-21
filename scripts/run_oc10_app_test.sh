#!/bin/bash

while [[ $# -gt 0 ]]
do
	key="$1"
	case ${key} in
		-a|--app)
			APP="$2"
			shift
			;;
		-f|--feature)
			BEHAT_FEATURE="$2"
			shift
			;;
		-m|--multiple)
			MULTIPLE="$2"
			shift
			;;
		-t|--type)
			TEST_TYPE="${2,,}"
			shift
			;;
		*)
			BEHAT_FEATURE="$1"
			;;
		esac
		shift
done

export TEST_SERVER_URL=http://localhost/core

cd "$HOME""/www/core/apps-external/""$APP" || exit

if [ -z "$MULTIPLE" ] || [ "$MULTIPLE" -lt 1 ]
then
	MULTIPLE=1
fi

for (( i=1; i<="$MULTIPLE"; i++ ))
do
	make test-acceptance-"$TEST_TYPE" BEHAT_FEATURE="$BEHAT_FEATURE"
done
