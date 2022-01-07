# OCIS: true if running with the ocis server
# RETRY: set integer if retires are needed
# FEATURE: the feature path from path $HOME/www/web/tests/e2e/cucumber
# example: bash -x scripts/web-e2e.sh --ocis --retry 5 kindergarten.feature

# $# is the number of arguments
# while loop looks for all provided arguments
# matching values inside the case statement
# shift takes the first one away
while [[ $# -gt 0 ]]; do
	key="$1"
	case ${key} in
	-o | --ocis)
		OCIS=true
		;;
	-r | --retry)
		RETRY="$2"
		shift
		;;
	-f | --feature)
		FEATURE="$2"
		shift
		;;
	*)
		export FEATURE="$1"
		;;
	esac
	shift
done

if [ "$OCIS" = true ]; then
	export OCIS=true
	export BASE_URL_OCIS=localhost:9200
else
	export BACKEND_HOST=http://localhost/core
	# do not use web integration app but the web itself
	export SERVER_HOST=http://localhost/web/dist
fi

export MIDDLEWARE_HOST=http://localhost:3000

if [[ -z "${RETRY}" ]]; then
	RETRY=0
fi

# assumes web repo cloned under "$HOME"/www/web/
cd "$HOME"/www/web/ || exit
yarn test:e2e:cucumber tests/e2e/cucumber/"${FEATURE}"
