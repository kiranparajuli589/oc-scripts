#!/bin/bash

cd "$HOME"/www/owncloud-test-middleware/ || exit

export BACKEND_HOST=http://localhost/core

yarn start
