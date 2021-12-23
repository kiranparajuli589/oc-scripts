#!/usr/bin/env bash

CEPH_CODE=$(cat "$HOME"/www/useful/scripts/temp/cehp.txt)

SCALITY_CODE=$(cat "$HOME"/www/useful/scripts/temp/scality.txt)

ELASTIC_CODE=$(cat "$HOME"/www/useful/scripts/temp/elastic.txt)

WAIT_FOR_FN=$(cat "$HOME"/www/useful/scripts/temp/wait.txt)

BROWSER_SERVICE=$(cat "$HOME"/www/useful/scripts/temp/browser.txt)

APP_LIST=("configreport" "contacts" "customgroups" "data_exporter" "diagnostics" "files_external_dropbox" "files_external_ftp" "files_external_s3" "files_ldap_home" "files_lifecycle" "files_mediaviewer" "files_onedrive" "files_paperhive" "files_pdfviewer" "files_texteditor" "firstrunwizard" "guests" "impersonate" "market" "metrics" "notes" "notifications" "oauth2" "objectstore" "openidconnect" "ownbrander" "richdocuments" "sharepoint" "smb_acl" "systemtags_management" "templateeditor" "testing" "theme-enterprise" "twofactor_backup_codes" "twofactor_totp" "user_external" "user_shibboleth" "web" "windows_network_drive" "wopi")

for app in "${APP_LIST[@]}"
do
  echo "$app"

  git clone https://github.com/owncloud/"$app".git "$HOME"/www/core/apps-external/"$app"/

  cd "$HOME"/www/core//apps-external/"$app"/ || exit

  git checkout -b update-starlark-waitfor

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
  if [[ -n $CEPH_LINE ]]
  then
    CEPH_START=$(($CEPH_LINE - 1))
    CEPH_END=$(($CEPH_START+7))

    sed "$CEPH_START","$CEPH_END"d .drone.star > new
    rm -rf .drone.star
    mv new .drone.star


    # add new code with waiting
    sed -i "$CEPH_START"s/^/"$CEPH_CODE"/ .drone.star
  fi

  # similarly for scality
  # remove this line "wait-for-it -t 600 scality:8000",
  sed -i "/wait-for-it -t 600 scality:8000/d" .drone.star

  SCALITY_LINE=$(sed -n "/\"name\": \"setup-scality\",/=" .drone.star)
  if [[ -n $SCALITY_LINE ]]
  then
    SCALITY_FROM=$(($SCALITY_LINE - 1))
    SCALITY_TO=$(($SCALITY_FROM+9))

    sed "$SCALITY_FROM","$SCALITY_TO"d .drone.star > new
    rm -rf .drone.star
    mv new .drone.star

    # add new code with waiting
    sed -i "$SCALITY_FROM"s/^/"$SCALITY_CODE"/ .drone.star
  fi

  ## similarly refactor code for elastic search
  ELASTIC_LINE=$(sed -n "/\"name\": \"setup-es\",/=" .drone.star)
  if [[ -n $ELASTIC_LINE ]]
  then
    ELASTIC_FROM=$(($ELASTIC_LINE-1))
    ELASTIC_TO=$(($ELASTIC_FROM+10))

    sed "$ELASTIC_FROM","$ELASTIC_TO"d .drone.star > new
    rm -rf .drone.star
    mv new .drone.star

    # add new code with waiting
    sed -i "$ELASTIC_FROM"s/^/"$ELASTIC_CODE"/ .drone.star
  fi


  ## browser service update

  BROWSER_SERVICE_LINE=$(sed -n "/def waitForBrowserService(phpVersion, isWebUi):/=" .drone.star)
  if [[ -n $BROWSER_SERVICE_LINE ]]
  then
    BROWSER_SERVICE_FROM=$(($BROWSER_SERVICE_LINE))
    B_TO=$(($BROWSER_SERVICE_FROM+10))

    echo $BROWSER_SERVICE_FROM
    echo $B_TO

    sed "$BROWSER_SERVICE_FROM","$B_TO"d .drone.star > new
    rm -rf .drone.star
    mv new .drone.star

    # add new code for browser service
    sed -i "$BROWSER_SERVICE_FROM"s/^/"$BROWSER_SERVICE"/ .drone.star
  fi


  # remove wait for server
  sed -i "/wait-for-it -t 600 server:80/d" .drone.star
  sed -i "/wait-for-it -t 600 federated:80/d" .drone.star

  # add new waitforserver func at the end for the starlark
  echo "$WAIT_FOR_FN" >> .drone.star

  ## remove reduced database section
  REDUCED_DB_LINE=$(sed -n "/\"reducedDatabases\": {/=" .drone.star)
  if [[ -n $REDUCED_DB_LINE ]]
  then
    REDUCED_FROM=$((REDUCED_DB_LINE))
    REDUCED_TO=$((REDUCED_FROM+9))

    sed "$REDUCED_FROM","$REDUCED_TO"d .drone.star > new
    rm -rf .drone.star
    mv new .drone.star
  fi
  # add constant declarations at the top of the file
  sed -i "1s/^/$CONSTANTS/" .drone.star

  $(docker run -v ${PWD}:/app owncloudci/bazel-buildifier bash -c "buildifier --mode=fix /app/.drone.star")

  git add .drone.star
  git commit -m "used owncloudci/wait-for docker image and PHP 7.4"

  PR_BODY="### Description<br>Update drone starlark to use owncloudci/wait-for and PHP7.4<br>### Related Issue:<br> - https://github.com/owncloud/QA/issues/707<br>_**Note:** This PR is created with a script. There may be some error which I will follow up later_<br>"
  PR_TITLE="[tests-only] Use owncloudci/wait-for docker image and PHP 7.4"
  gh pr create -a @me -b "$PR_BODY" -p "Current: QA/CI/TestAutomation" -r phil-davis -t "$PR_TITLE"

done
