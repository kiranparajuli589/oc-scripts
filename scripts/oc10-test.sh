#!/bin/bash

# $1 -> acceptance test type: api, cli or webui

export TEST_SERVER_URL=http://localhost/core
export TEST_SERVER_FED_URL=http://localhost/owncloud-fed
if [ $1 == 'webui' ]
then
	export SELENIUM_PORT=4444
fi

cd $HOME/www/core
make test-acceptance-$1 BEHAT_FEATURE=$2