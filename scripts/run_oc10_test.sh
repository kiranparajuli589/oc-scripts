#!/bin/bash

# $1 -> acceptance test type: api, cli or webui
# $2 -> behat feature path; `tests/acceptance/features/` is prefixed
# ex: apiMain/some.feature:20

export TEST_SERVER_URL=http://localhost/core
# export TEST_SERVER_FED_URL=http://localhost/owncloud-fed
if [ "$1" = 'webui' ]
then
	export SELENIUM_PORT=4444
fi

cd "$HOME"/www/core || exit
make test-acceptance-"$1" BEHAT_FEATURE=tests/acceptance/features/"$2"
