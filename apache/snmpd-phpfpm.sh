#!/bin/sh
#
# Query php-fpm about its status and stats
#

# Adjust those variables to your needs
HTTPUSER="login"
HTTPPASS="pass"

HOSTNAME=`/bin/hostname -f`
STATUS_CALL="/usr/bin/lynx -dump -auth=${HTTPUSER}:${HTTPPASS} https://${HOSTNAME}/status"

case "$1" in
    connections)
		# total number of accepted connections since start
		$STATUS_CALL | awk '/accepted conn:/ {print $3;}'
		;;
		
    listenqueue)
		# current requests in the listen queue
		$STATUS_CALL | awk '/listen queue:/ {print $3;}'
		;;

    idle)
		# current number of idle processes
		$STATUS_CALL | awk '/idle processes:/ {print $3;}'
		;;

    active)
		# current number of active processes
		$STATUS_CALL | awk '/active processes:/ {print $3;}'
		;;

    all)
    		# all data
		$STATUS_CALL | awk '/^(accepted conn|listen queue|idle processes|active processes):/ {print $3}'
		;;
	
    *)
		# default
		echo 'usage : phpfpm-status connections|listenqueue|idle|active|all'
		;;

esac

exit 0

