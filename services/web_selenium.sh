#!/bin/bash

docker run --rm -d \
	--network="host" \
	-v /dev/shm:/dev/shm \
	-v "${REMOTE_UPLOAD_DIR:-$HOME/www/owncloud/middleware/filesForUpload}":"${LOCAL_UPLOAD_DIR:-/uploads}":ro \
	--name web-tests-selenium \
	selenium/standalone-chrome-debug:3.141.59
