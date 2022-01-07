# OCIS: true if running with the ocis server
# RETRY: set integer if retires are needed
# FEATURE: the feature path from path $HOME/www/web/tests/e2e/cucumber

while [[ $# -gt 0 ]]
do
	key="$1"
	case ${key} in
		-o|--ocis)
			OCIS="$2"
			shift
			;;
		-f|--feature)
			FEATURE="$2"
			shift
			;;
    -r|--retry)
      RETRY="$2"
      shift
      ;;
      *)
			FEATURE="$1"
			;;
		esac
		shift
done

if [ "$OCIS" = true ]
then
  BACKEND_HOST=https://localhost:9200
else
  BACKEND_HOST=http://localhost/core
  SERVER_HOST=http://localhost/web/dist
fi

MIDDLEWARE_HOST=http://localhost:3000

if [[ -z "${RETRY}" ]]
then
  RETRY=0
fi

cd "$HOME"/www/web/ || exit
yarn test:e2e:cucumber tests/e2e/cucumber/"${FEATURE}"
