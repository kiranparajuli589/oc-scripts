#!/bin/bash

export TEST_SERVER_URL=${TEST_SERVER_URL:-"http://localhost/owncloud/core"}
export BEHAT_FILTER_TAGS=${BEHAT_FILTER_TAGS:-"/tmp/downloads"}
export DOWNLOADS_DIRECTORY=${DOWNLOADS_DIRECTORY:-"/tmp/downloads"}
export SELENIUM_HOST=${SELENIUM_HOST:-"localhost"}
export SELENIUM_PORT=${SELENIUM_PORT:-"4444"}
export BROWSER=${BROWSER:-"chrome"}
export PLATFORM=${PLATFORM:-"Linux"}
export TEST_TYPE=${TEST_TYPE:-"api"}

MAKE_PARAM="test-acceptance-core-"

cd "$APP_ROOT" || exit
make $MAKE_PARAM"$TEST_TYPE" BEHAT_FEATURE=tests/acceptance/features/"$BEHAT_FEATURE"
