#!/bin/bash

cd "$HOME"/www/owncloud-test-middleware/ || exit

if [ "$1" = "ocis"  ]
then
  export BACKEND_HOST=https://localhost:9200
else
  export BACKEND_HOST=http://localhost/core
fi

yarn start
