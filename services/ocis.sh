#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

export OCIS_URL="https://host.docker.internal:9200"
export OCIS_INSECURE="true"
export OCIS_LOG_LEVEL="debug"
export OCIS_LOG_PRETTY="true"
export OCIS_LOG_COLOR="true"

STORAGE_DRIVER=${STORAGE_DRIVER:-"ocis"}
export STORAGE_USERS_DRIVER=$STORAGE_DRIVER
export STORAGE_USERS_DRIVER_LOCAL_ROOT="/tmp/ocis/local/root"
export STORAGE_USERS_DRIVER_OCIS_ROOT="/tmp/ocis/storage/users"
export STORAGE_SYSTEM_DRIVER_OCIS_ROOT="/tmp/ocis/storage/metadata"

export PROXY_ENABLE_BASIC_AUTH=True

export SHARING_USER_JSON_FILE="/tmp/ocis/shares.json"

export WEB_UI_CONFIG="$SCRIPT_DIR/../ocis-config/web-config.json"

export IDP_IDENTIFIER_REGISTRATION_CONF="$SCRIPT_DIR/../ocis-config/idp.yml"

export SETTINGS_DATA_PATH="/tmp/ocis/settings",

export IDM_CREATE_DEMO_USERS=True
export IDM_ADMIN_PASSWORD="admin"

OCIS_ROOT=${OCIS_ROOT:-"$HOME""/go/src/github.com/owncloud/ocis"}

while test $# -gt 0; do
	key="$1"
	case ${key} in
	-h | --help)
		echo "==============================="
		echo "Welcome to start ocis script ;)"
		echo "==============================="
		echo "Start ocis server at https://host.docker.internal:9200"
		echo ""
		echo "Options:"
		echo "--------"
		echo "-h, --help   ➡  shows brief help about the script"
		echo "-f, --fresh  ➡  start 'ocis' server with fresh code"
		echo ""
		echo "Environments:"
		echo "-------------"
		echo "STORAGE_DRIVER  ➡  storage driver to use for the server"
		echo -e "\t\t   DEFAULT: 'ocis'"
		echo -e "\t\t   OPTIONS: 'ocis' & 'owncloud'"
		echo "OCIS_ROOT       ➡  path where the 'owncloud-test-middleware' repository is cloned"
		echo -e "\t\t   DEFAULT: $HOME/go/src/github.com/owncloud/ocis"
		echo -e "\t\t   CAUTION: please do not include the last trailing slash"
		echo ""
		exit 0
		;;
	-f | --fresh)
		cd "$OCIS_ROOT" || exit
		git stash && git checkout master && git pull
		rm -rf "$HOME"/.ocis
		make clean
		make generate
		cd "$OCIS_ROOT""/ocis" || exit
		make clean
		if make build; then
			echo "ocis build successful"
		else
			echo "ocis build failed"
			exit 1
		fi
		IDM_ADMIN_PASSWORD="admin" bin/ocis init --insecure true
		shift
		;;
	-c | --clean)
		cd "$OCIS_ROOT" || exit
		rm -rf "$HOME"/.ocis
		make clean
		make generate
		cd "$OCIS_ROOT""/ocis" || exit
		make clean
		if make build; then
			echo "ocis build successful"
		else
			echo "ocis build failed"
			exit 1
		fi
		IDM_ADMIN_PASSWORD="admin" bin/ocis init --insecure true
		shift
		;;
	esac
	shift
done

"$OCIS_ROOT""/ocis/bin/ocis" server
