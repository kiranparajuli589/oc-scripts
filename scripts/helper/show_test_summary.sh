#!/bin/bash

echo "Test Summary:"
echo "________________________________"

RESULT_ARRAY=$1

for i in "${RESULT_ARRAY[@]}"
do
	STATUS=$( [ "${RESULT_ARRAY[$i]}" == 0 ] && echo "Passed (0)" || echo "Failed (1)" )
	echo -e "Iteration: ""$i""\tStatus: ""$STATUS"
done
