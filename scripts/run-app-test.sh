while [[ $# -gt 0 ]]
do
	key="$1"
	case ${key} in
		-a|--app)
			APP="$2"
			shift
			;;
		-f|--feature)
			BEHAT_FEATURE="$2"
			shift
			;;
		-m|--multiple)
			MULTIPLE="$2"
			shift
			;;
		-t|--type)
			TEST_TYPE="${2,,}"
			shift
			;;
		*)
			BEHAT_FEATURE="$1"
			;;
		esac
		shift
done

echo "APP: $APP"
echo "TEST_TYPE: $TEST_TYPE"
echo "MULTIPLE: $MULTIPLE"
echo "BEHAT_FEATURE: $BEHAT_FEATURE"

export TEST_SERVER_URL=http://localhost/core

cd $HOME/www/core/apps-external/"$APP"

for (( i=1; i<=$MULTIPLE; i++ ))
do
	make test-acceptance-"$TEST_TYPE" BEHAT_FEATURE="$BEHAT_FEATURE"
done

echo "Boom!"
