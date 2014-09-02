#!/bin/sh
#
# Query a remote perfSONAR Lookup Service (old style XML-LS)
#

PSPATH='/home/antoine/perfSONAR/'
LSCLIENT=$PSPATH'psps-client.pl'
SERVER='--server '$2
PORT='--port '$3
ENDPOINT='--endpoint '$4
MYENDPOINT=$4
REQ_TOTAL=$PSPATH'requests/xpath-count-services.xml'

cd $PSPATH

total_services() {
	if [ "${MYENDPOINT%/*/*}" = "/perfsonar-java-xml-ls" ]; then
		$LSCLIENT $SERVER $PORT $ENDPOINT $REQ_TOTAL | awk -F 'value>' '/value>[0-9]+/ {sub(/<\//, "", $2) ;print $2}'
	else
		$LSCLIENT $SERVER $PORT $ENDPOINT $REQ_TOTAL | awk -F 'psservice:datum' '/<nmwg:data/ {sub(/<\//, "", $2) ; sub(/ xmlns:psservice=\"http:\/\/ggf.org\/ns\/nmwg\/tools\/org\/perfsonar\/service\/1.0\/\">/, "", $2); print $2}'
	fi
}

case "$1" in
    total)
		# total number of services registered in the LS
		total_services
		;;
		
    all)
    		# all data
		total_services
		;;
	
    *)
		# default
		echo 'usage : perfsonar-ls all|total SERVER PORT ENDPOINT'
		;;

esac

exit 0

