#!/bin/bash

docker run --rm -d \
	--network="host" \
	-v downloads:/home/seluser/Downloads \
	--name core-tests-selenium \
	selenium/standalone-chrome-debug:3.141.59-oxygen
