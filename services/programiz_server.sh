#!/bin/bash

export SERVER_ROOT=${SERVER_ROOT:-"$HOME""/development/programiz/server"}

export ASPNETCORE_ENVIRONMENT=Development
export PM_DB_HOST=programiz_pro_local_db
export PM_DB_PORT=3306
export PM_DB_NAME=programiz_web
export PM_DB_USER=dev
export PM_DB_PASSWORD=thepeeps
export PM_SOLR_HOST=programiz_pro_local_solr
export PM_SOLR_PORT=8983
export PM_AUTH_DB_HOST=programiz_pro_local_auth_db
export PM_AUTH_DB_PORT=3306
export PM_AUTH_DB_NAME=programiz_authentication
export PM_AUTH_DB_USER=dev
export PM_AUTH_DB_PASSWORD=thepeeps
export PM_PDF_GEN_HOST=programiz_pro_local_thecodingmachine
export PM_PDF_GEN_POST=3000
export GOOGLE_APPLICATION_CREDENTIALS=./credentials/pub_sub_key=json
export REDIS_HOST=programiz_pro_local_redis
export REDIS_PORT=6379
export REDIS_USER=default
export REDIS_PASSWORD=password

cd "$SERVER_ROOT" || exit
./scripts/start_devel_db.sh
