#!/bin/sh
######
# This script query the mysql deamon about status
# All the information is extracted from the mysqladmin command output
# A special MySQL user is needed to access this command.
#
# You can either ask for (first arg)
# - questions		number of questions asked to the mysql deamon
# - slow		number of slow queries (>10 seconds)
# - connections		number of open connections to MySQL
# - opentables		number of open tables
# - all			output of all values, one per line
#
# Copyright Antoine Delvaux 2002 - 2014

#
# We need an snmpd user with restricted privileges (only show status and replication client)
USER="snmpd"
PASS="snmpd"
HOST="mysql.cassiopea.org"
MYSQLADMIN_CALL="/usr/bin/mysqladmin -h ${HOST} -u ${USER} -p${PASS}"
MYSQLADMIN_OUT=`$MYSQLADMIN_CALL status`
MYSQLSLAVE_OUT=`/usr/bin/mysql -h ${HOST} -u ${USER} -p${PASS} -e "SHOW SLAVE STATUS\G" | awk '/Seconds_Behind_Master:/ {print $2}'`

case "$1" in
    questions)
		# number of questions asked to the mysql deamon
		echo $MYSQLADMIN_OUT | awk '{print $6}'
		;;
		
    slow)
		# number of slow queries (>10 seconds)
		echo $MYSQLADMIN_OUT | awk '{print $9}'
		;;

    connections)
		# number of opened connections
		$MYSQLADMIN_CALL status | awk '{print $4}'
		#mysql -u snmpd -psnmpd -N -B -e "show status like 'Connections'" | awk '{print $2}'
		#mysqladmin -u snmpd -psnmpd extended-status | awk '/.*Threads_connected.*/ {print $4}'
		;;

    opentables)
		# number of opened tables
		echo $MYSQLADMIN_OUT | awk '{print $17/1000}'
		;;

    slave)
		# number of seconds behind master
		echo $MYSQLSLAVE_OUT
		;;

    all)
    		# all data except for slave
		echo $MYSQLADMIN_OUT | awk '{print $6}'
		echo $MYSQLADMIN_OUT | awk '{print $9}'
		echo $MYSQLADMIN_OUT | awk '{print $4}'
		echo $MYSQLADMIN_OUT | awk '{print $17/1000}'
		;;
	
    all-slave)
    		# all data for slave
		echo $MYSQLADMIN_OUT | awk '{print $6}'
		echo $MYSQLADMIN_OUT | awk '{print $9}'
		echo $MYSQLADMIN_OUT | awk '{print $4}'
		echo $MYSQLADMIN_OUT | awk '{print $17/1000}'
		echo $MYSQLSLAVE_OUT
		;;
	
    *)
		# default
		echo 'usage : mysqladmin-status questions|slow|connections|opentables|all|all-slave'
		;;

esac

exit 0

