#!/bin/sh
# Mostly copied from https://nickb.dev/blog/routing-select-docker-containers-through-wireguard-vpn


# PIA provided scripts to get the fastest region and connect to it
./get_region.sh

function finish {
    echo "$(date): Shutting down vpn"
    wg-quick down /config/pia.conf
}

#$WG_SERVER_IP?
#VPN_IP=$(grep -Po 'Endpoint\s=\s\K[^:]*' /etc/wireguard/wgnet0.conf)

# Our IP address should be the VPN endpoint for the duration of the
# container, so this function will give us a true or false if our IP is
# actually the same as the VPN's
function current_ip {
    curl --silent --show-error --retry 10 --fail https://www.privateinternetaccess.com/site-api/get-location-info | jq -r '.ip' 
}

# If our container is terminated or interrupted, we'll be tidy and bring down
# the vpn
trap finish TERM INT

# Every minute we check to our IP address
while [[ current_ip == $VPN_IP ]]; do
    sleep 60;
done

echo "$(date): VPN IP address not detected"