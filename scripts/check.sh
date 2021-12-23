#!/usr/bin/env bash
cd "$HOME"/www/core//apps-external/client-updater-server/ || exit
CEPH_LINE=$(sed -n "/\"name\": \"setup-ceph\",/=" .drone.star)

if [[ -z $CEPH_LINE ]]
then
  echo "-z"
else
  echo "not -z"
fi