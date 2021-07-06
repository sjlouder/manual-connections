FROM linuxserver/wireguard

COPY *.sh /opt/PIA/
COPY ca.rsa.4096.crt /opt/PIA/

WORKDIR /opt/PIA
# CMD ? (custom script to run get-region or get-token or connect script based on env variables)
ENTRYPOINT ["bash", "/opt/PIA/startup.sh"]

# HEALTHCHECK --interval=2m --timeout=10s --start-period=15s \
# 	CMD bash healthcheck.sh

# Options
# 	Specify location
# 	If no location, select lowest latency
# 		requires user/pass
# 	Cache access tokens per region
# 		reconfigure connect script to use region specific config