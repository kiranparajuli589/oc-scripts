#!/bin/bash

# set your name here for labels and ssh-key setup
ME=$(whoami) 
SERVER_NAME=eos-ocis-test

# create server
hcloud server create --type cx21 --image ubuntu-20.04 --ssh-key $ME --name $SERVER_NAME --label owner=$ME --label for=test --label from=eos-compose

IPADDR=$(hcloud server ip $SERVER_NAME)

ssh -t root@$IPADDR apt-get update -y
ssh -t root@$IPADDR apt-get install -y git screen docker.io docker-compose ldap-utils
ssh -t root@$IPADDR git clone https://github.com/owncloud-docker/compose-playground.git
ssh -t root@$IPADDR "cd compose-playground/examples/eos-compose-acceptance-tests && ./build"