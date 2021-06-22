#!/bin/bash

ipAddress=$(curl https://www.privateinternetaccess.com/site-api/get-location-info | jq -r '.ip') || exit 1
exposed=$(curl -X POST https://www.privateinternetaccess.com/site-api/exposed-check -F 'ipAddress=$ipAddress)' | jq '.status') || exit 1; 
[[ $exposed == false ]] || exit 1

#CMD curl -X POST https://www.privateinternetaccess.com/site-api/exposed-check -F 'ipAddress=$(curl ipinfo.io/ip)' = 'true || exit 1