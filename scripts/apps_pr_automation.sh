#!/usr/bin/env bash

# TODO: dir list from app-store
 source "$HOME"/www/useful/app_list.sh

 APP_STORE=${APP_STORE:-"$HOME/www/owncloud/app_store/"}


work_to_perform() {
 composer u
}

for APP in "${APP_LIST[@]}"
do
  echo "$APP"
  # check if app already exists in apps-store
  if [[ ! -d "$APP_STORE""$APP" ]]
  then
    git clone "https://github.com/owncloud/""$APP"".git" "$APP_STORE""$APP" --depth=1
  fi

  cd "$HOME""/www/owncloud/apps-store/""$APP" || exit
  # proceed only if the repository is actually an owncloud core app
  if [ -d appinfo ]
  then
    # prepare git stage
    git stash && git stash clear
    git checkout master && git pull
    git checkout -b composer-allow-plugins

    # implement your work inside this function
    work_to_perform

    # commit the changes and then push
    git add . && git commit -S -m "Add composer allow-plugins"

    # create pr for the remote repository
    PR_TITLE=${PR_TITLE:-"Add composer allow-plugins"}
    BODY_FILE=${BODY_FILE:-"$HOME/www/useful/pr_body.md"}
    gh pr create -a @me -B master --body-file "$BODY_FILE" -f -p "Current: QA/CI/TestAutomation" -r phil-davis -t "$PR_TITLE"
  fi
done
