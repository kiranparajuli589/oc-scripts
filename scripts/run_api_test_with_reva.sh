#!/bin/bash

export TEST_SERVER_URL="http://localhost:20080"
export OCIS_REVA_DATA_ROOT="/var/tmp/reva/"
export DELETE_USER_DATA_CMD="rm -rf /var/tmp/reva/data/nodes/root/* /var/tmp/reva/data/nodes/*-*-*-* /var/tmp/reva/data/blobs/*"
export STORAGE_DRIVER="OCIS"
export SKELETON_DIR="$HOME/www/owncloud/core/apps-external/testing/data/apiSkeleton"
export TEST_WITH_LDAP="true"
export REVA_LDAP_HOSTNAME="localhost"
export TEST_REVA="true"
export SEND_SCENARIO_LINE_REFERENCES="true"
export BEHAT_FILTER_TAGS="~@notToImplementOnOCIS&&~@toImplementOnOCIS&&~comments-app-required&&~@federation-app-required&&~@notifications-app-required&&~systemtags-app-required&&~@provisioning_api-app-required&&~@preview-extension-required&&~@local_storage&&~@skipOnOcis-OCIS-Storage&&~@skipOnOcis&&~@issue-ocis-3023"
export EXPECTED_FAILURES_FILE=$HOME/go/src/github.com/cs3org/reva/tests/acceptance/expected-failures-on-OCIS-storage.md

cd "$HOME"/www/owncloud/core || exit

make test-acceptance-api BEHAT_FEATURE=tests/acceptance/features/"$1"
