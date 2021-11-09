#!/bin/bash

export SERVER_HOST=http://localhost/web/dist
export BACKEND_HOST=http://localhost/core
export REMOTE_BACKEND_HOST=http://localhost/owncloud-fed

cd $HOME/www/web/tests/acceptance

declare -a PASS

if [ ! -z "$MULTIPLE" ]
then
	for index in {1..2}
	do
		echo "RUNNING INDEX: $index"
		if yarn run test:acceptance:oc10 "$1"
		then
			PASS+="Run $index -> PASSED"
		else
			PASS+="Run $index -> FAILED"
		fi
	done
	for statement in $PASS[@]; do
		echo $statement
	done
else
	echo "NOT MULTIPLE"
	yarn run test:acceptance:oc10 "$1"
fi
exit 0
