#!/bin/bash

export BACKEND_HOST=https://localhost:9200
export EXPECTED_FAILURES_FILE=$HOME/www/web/tests/acceptance/expected-failures-with-ocis-server-owncloud-storage.md
export LOCAL_UPLOAD_DIR=/uploads
export NODE_TLS_REJECT_UNAUTHORIZED=0
export OCIS_REVA_DATA_ROOT=/tmp/ocis/owncloud/data/
export RUN_ON_OCIS=true
export SERVER_HOST=https://localhost:9200
export TESTING_DATA_DIR=$HOME/www/core/app-external/testing/data/
export TEST_PATHS="tests/acceptance/features/webUILogin tests/acceptance/features/webUINotifications tests/acceptance/features/webUIPrivateLinks tests/acceptance/features/webUIPreview tests/acceptance/features/webUIAccount tests/acceptance/features/webUIAdminSettings tests/acceptance/features/webUIComments tests/acceptance/features/webUITags tests/acceptance/features/webUIWebdavLockProtection tests/acceptance/features/webUIWebdavLocks "
export TEST_TAGS=not @skip and not @skipOnOCIS and not @notToImplementOnOCIS
export VISUAL_TEST=true
export WEB_UI_CONFIG=/srv/config/drone/ocis-config.json

yarn test:acceptance:ocis tests/acceptance/features/webUIDeleteFilesFolders/deleteFilesFolders.feature:77