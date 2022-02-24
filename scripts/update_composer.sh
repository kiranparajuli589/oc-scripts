#!/usr/bin/env bash

# TODO: dir list from app-store
# source "$HOME"/www/useful/app_list.sh

for APP in "${APP_LIST[@]}"
do
  echo "$APP"
  # check if app already exists in apps-store
  if [[ ! -d "$HOME""/www/core/apps-store/""$APP" ]]
  then
    git clone "https://github.com/owncloud/""$APP"".git" "$HOME""/www/core/apps-store/""$APP" --depth=1
  fi

  cd "$HOME""/www/core/apps-store/""$APP" || exit
  if [ -f composer.json ]
  then
    git stash && git stash clear
    git checkout master
    git pull
    git checkout -b composer-allow-plugins
    composer u
    git add .
    git commit -S -m "Add composer allow-plugins"

    PR_TITLE="Add composer allow-plugins"
    BODY_FILE="$HOME""/www/useful/update_composer_pr_body.md"

    gh pr create -a @me -B master --body-file "$BODY_FILE" -f -p "Current: QA/CI/TestAutomation" -r phil-davis -t "$PR_TITLE"
  else
    cd || exit
    rm -rf "$HOME""/www/core/apps-store/""$APP"
  fi
done
