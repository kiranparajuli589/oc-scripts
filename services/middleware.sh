#!/bin/bash

# $1 -> if -o: starts the service with ocis
#				else: starts the service with oc10

# assumes middleware repo cloned under:
cd "$HOME"/www/owncloud-test-middleware/ || exit

if [ "$1" = "-o"  ]
then
  export BACKEND_HOST=https://localhost:9200
else
  export BACKEND_HOST=http://localhost/core
fi


yarn start
