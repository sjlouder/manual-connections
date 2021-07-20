#!/bin/sh
# Mostly copied from https://nickb.dev/blog/routing-select-docker-containers-through-wireguard-vpn


# PIA provided scripts to get the fastest region and connect to it
./get_region.sh

VPN_IP=$(grep -Po 'Endpoint\s=\s\K[^:]*' /config/pia.conf)
echo VPN IP: $VPN_IP

# If our container is terminated or interrupted, we'll be tidy and bring down
# the vpn
function finish {
    echo "$(date): Shutting down vpn"
    wg-quick down /config/pia.conf
}

trap finish TERM INT

# Every 15 minutes we check our IP address
# Our IP address should be the VPN endpoint for the duration of the
# container, so this function will give us a true or false if our IP is
# actually the same as the VPN's
function check_current_ip {
	currentIP=$(curl --silent --show-error --retry 10 --fail https://www.privateinternetaccess.com/site-api/get-location-info | jq -r '.ip')
	[[ $currentIP == $VPN_IP ]] && return 0 || return 1
}

echo 'Beginning 15 minute IP check loop'
while check_current_ip
do
	#echo "$(date): IP validation check succeeded ($currentIP)"
    sleep (60*15);
done

echo "$(date): VPN IP address not detected ($currentIP)"