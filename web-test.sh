#!/bin/bash

export SERVER_HOST=http://localhost/web/dist
export BACKEND_HOST=http://localhost/core
export REMOTE_BACKEND_HOST=http://localhost/owncloud-fed

cd $HOME/www/web/
yarn run test:acceptance:oc10 "$1"

