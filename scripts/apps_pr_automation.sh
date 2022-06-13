#!/bin/bash

APPS_STORE=${APPS_STORE:-"$HOME/www/owncloud/apps_store/"}

# app list file is expected to contain a list of apps to be checked
# if app list file path is not provided, exit with an error
if [ -z "$APP_LIST" ]
then
	echo "Please set APP_LIST variable to the path to the app list file"
	exit 1
else
	# shellcheck disable=SC1090
	source "${APP_LIST}"
fi


work_to_perform() {
 composer u
}

for APP in "${APP_LIST[@]}"
do
  echo "$APP"
  # check if the app already exists in the apps-store
  if [[ ! -d "$APPS_STORE""$APP" ]]
  then
    git clone "https://github.com/owncloud/""$APP"".git" "$APPS_STORE""$APP" --depth=1
  fi

  cd "$HOME""/www/owncloud/apps-store/""$APP" || exit
  # proceed only if the repository is actually an owncloud core app
  if [ -d appinfo ]
  then
    # prepare git stages
    git stash && git stash clear
    git checkout master && git pull
    git checkout -b composer-allow-plugins

    # implement your work inside this function
    work_to_perform

    # commit the changes and then push to the remote
    git add . && git commit -S -m "Add composer allow-plugins"

    # create PR for the remote repository
    PR_TITLE=${PR_TITLE:-"Add composer allow-plugins"}
    BODY_FILE=${BODY_FILE:-"$HOME/www/useful/pr_body.md"}
    gh pr create -a @me -B master --body-file "$BODY_FILE" -f -p "Current: QA/CI/TestAutomation" -r phil-davis -t "$PR_TITLE"
  fi
done
