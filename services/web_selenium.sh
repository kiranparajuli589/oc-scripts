#!/bin/bash

BROWSER=$1

# if empty $1, then use default browser
if [ -z "$BROWSER" ]; then
	BROWSER="chrome"
fi

if [ "$BROWSER" != "chrome" ] && [ "$BROWSER" != "firefox" ]; then
	echo "Please provide a browser option: chrome or firefox"
	exit 1
fi

SELENIUM_STANDALONE_CHROME="selenium/standalone-chrome:104.0-20220812"
SELENIUM_STANDALONE_FIREFOX="selenium/standalone-firefox:104.0-20220812"

if [ "$BROWSER" == "chrome" ]; then
	SELENIUM=$SELENIUM_STANDALONE_CHROME
elif [ "$BROWSER" == "firefox" ]; then
	SELENIUM=$SELENIUM_STANDALONE_FIREFOX
fi

docker run --rm -d \
	--network="host" \
	-v /dev/shm:/dev/shm \
	-v "${REMOTE_UPLOAD_DIR:-$HOME/www/owncloud/middleware/filesForUpload}":"${LOCAL_UPLOAD_DIR:-/uploads}":ro \
	--name web-tests-selenium \
	"$SELENIUM"
