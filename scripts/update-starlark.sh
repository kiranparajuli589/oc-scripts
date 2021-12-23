#!/usr/bin/env bash

CEPH_CODE=$(cat "$HOME"/www/useful/scripts/temp/cehp.txt)

SCALITY_CODE=$(cat "$HOME"/www/useful/scripts/temp/scality.txt)

ELASTIC_CODE=$(cat "$HOME"/www/useful/scripts/temp/elastic.txt)

WAIT_FOR_FN=$(cat "$HOME"/www/useful/scripts/temp/wait.txt)

BROWSER_SERVICE=$(cat "$HOME"/www/useful/scripts/temp/browser.txt)

APP_LIST=("calendar")
#APP_LIST=("calendar" "client-updater-server" "configreport" "contacts" "customgroups" "data_exporter" "diagnostics" "files_external_dropbox" "files_external_ftp" "files_external_s3" "files_ldap_home" "files_lifecycle" "files_mediaviewer" "files_onedrive" "files_paperhive" "files_pdfviewer" "files_texteditor" "firstrunwizard" "guests" "impersonate" "market" "metrics" "notes" "notifications" "oauth2" "objectstore" "openidconnect" "ownbrander" "richdocuments" "sharepoint" "smb_acl" "systemtags_management" "templateeditor" "testing" "theme-enterprise" "twofactor_backup_codes" "twofactor_totp" "user_external" "user_shibboleth" "web" "windows_network_drive" "wopi")

for app in "${APP_LIST[@]}"
do
  echo "$app"

  git clone https://github.com/owncloud/"$app".git "$HOME"/www/core/apps-external/"$app"

  cd "$HOME"/www/core//apps-external/"$app"/ || exit

  CONSTANTS='OC_CI_ALPINE = \"owncloudci\/alpine:latest\"\nOC_CI_WAIT_FOR = \"owncloudci\/wait-for:latest\"\nOC_CI_NODEJS = \"owncloudci\/nodejs:14\"\nOC_UBUNTU = \"owncloud\/ubuntu:20.04\"\n\n'

  # replace with constants
  sed -i "s/\"owncloud\/ubuntu:18.04\"/OC_UBUNTU/" .drone.star
  sed -i "s/\"owncloud\/ubuntu:16.04\"/OC_UBUNTU/" .drone.star
  sed -i "s/\"owncloud\/alpine:latest\"/OC_CI_ALPINE/" .drone.star

  # replace `"phpVersions": ["7.3"],` to `"phpVersions": ["7.4"],`
  sed -i "s/\"7.3\", \"7.4\"/\"7.4\"/" .drone.star
  sed -i "s/\"7.3\"/\"7.4\"/" .drone.star

  # remove this line "wait-for-it -t 600 ceph:80",
  sed -i "/wait-for-it -t 600 ceph:80/d" .drone.star

  CEPH_LINE=$(sed -n "/\"name\": \"setup-ceph\",/=" .drone.star)
  START=$(($CEPH_LINE - 1))
  END=$(($START+7))

  sed "$START","$END"d .drone.star > new
  rm -rf .drone.star
  mv new .drone.star


  # add new code with waiting
  sed -i "$START"s/^/"$CEPH_CODE"/ .drone.star

  # similarly for scality
  # remove this line "wait-for-it -t 600 scality:8000",
  sed -i "/wait-for-it -t 600 scality:8000/d" .drone.star

  SCALITY_LINE=$(sed -n "/\"name\": \"setup-scality\",/=" .drone.star)
  FROM=$(($SCALITY_LINE - 1))
  TO=$(($FROM+9))

  sed "$FROM","$TO"d .drone.star > new
  rm -rf .drone.star
  mv new .drone.star

  # add new code with waiting
  sed -i "$FROM"s/^/"$SCALITY_CODE"/ .drone.star

  ## similarly refactor code for elastic search
  ELASTIC_LINE=$(sed -n "/\"name\": \"setup-es\",/=" .drone.star)

  ELASTIC_FROM=$(($ELASTIC_LINE - 1))
  ELASTIC_TO=$(($ELASTIC_FROM+10))

  sed "$ELASTIC_FROM","$ELASTIC_TO"d .drone.star > new
  rm -rf .drone.star
  mv new .drone.star

  # add new code with waiting
  sed -i "$ELASTIC_FROM"s/^/"$ELASTIC_CODE"/ .drone.star


  ## browser service update

  B_S=$(sed -n "/def waitForBrowserService(phpVersion, isWebUi):/=" .drone.star)
  B_FROM=$(($B_S))
  B_TO=$(($B_FROM+10))

  echo $B_FROM
  echo $B_TO

  sed "$B_FROM","$B_TO"d .drone.star > new
  rm -rf .drone.star
  mv new .drone.star

  # add new code for browser service
  sed -i "$B_FROM"s/^/"$BROWSER_SERVICE"/ .drone.star


  # remove wait for server
  sed -i "/wait-for-it -t 600 server:80/d" .drone.star
  sed -i "/wait-for-it -t 600 federated:80/d" .drone.star

  # add new waitforserver func at the end for the starlark
  echo "$WAIT_FOR_FN" >> .drone.star

  ## remove reduced database section
  REDUCED_DB_LINE=$(sed -n "/\"reducedDatabases\": {/=" .drone.star)
  REDUCED_FROM=$((REDUCED_DB_LINE))
  REDUCED_TO=$((REDUCED_FROM+9))

  sed "$REDUCED_FROM","$REDUCED_TO"d .drone.star > new
  rm -rf .drone.star
  mv new .drone.star

  # add constant declarations at the top of the file
  sed -i "1s/^/$CONSTANTS/" .drone.star

  $(docker run -v ${PWD}:/app owncloudci/bazel-buildifier bash -c "buildifier --mode=fix /app/.drone.star")

  PR_BODY="###Description\nUpdate drone starlark to use owncloudci/wait-for and PHP7.4\n###Related Issue:\n- - https://github.com/owncloud/QA/issues/707\n___**Note:** This PR is created with an script. There may be some error which I will follow up later_\n"
  PR_TITLE="[tests-only] Use owncloudci/wait-for docker image and used PHP 7.4"

  git checkout -b update-starlark-waitfor
  gh pr create -a @me -B master -b "$PR_BODY" -H update-starlark-waitfor -l QA-team -p "Current: QA/CI/TestAutomation" -r @phil-davis -t "$PR_TITLE"

done
