#!/bin/bash

export SERVER_HOST=http://localhost/web/dist
export BACKEND_HOST=http://localhost/core
export REMOTE_BACKEND_HOST=http://localhost/owncloud-fed
export MIDDLEWARE_HOST="http://localhost:3000"

cd "$HOME"/www/web/tests/acceptance || exit

yarn run test:acceptance:oc10 "$1"

