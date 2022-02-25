#!/bin/bash

gh repo list owncloud --json name --jq '.[]|.name' -L 1000 > list.txt
