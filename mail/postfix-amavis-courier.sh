#!/bin/sh
# Prints out mail server stats for publication through snmpd

# Port variables, to catch incoming or amavis filtered connexions
INCOMING_PORT="1002(4|6)"
FILTERED_PORT=10025

# We take the list of running processes
PS=`ps ax`

case "$1" in
	incoming)
		echo "$PS" | awk "/${INCOMING_PORT}/ { i++ } END { printf (\"%d\n\", i) }"
		;;
	
	filtered)
		echo "$PS" | awk "/${FILTERED_PORT}/ { i++ } END { printf (\"%d\n\", i) }"
		;;
	
	smtpd)
		# Useful summary for smtpd processes
		echo "$PS" | awk "/${INCOMING_PORT}/ { i++ } /${FILTERED_PORT}/ { f++ } END { printf (\"%d\n%d\n\", i, f) }"
		;;

	imapd)
		echo "$PS" | awk "\$5 ~ /\/usr\/bin\/imapd/ { i++ } END { printf (\"%d\n\", i) }"
		;;

	pop3d)
		echo "$PS" | awk "\$5 ~ /\/usr\/lib\/courier\/courier\/courierpop3d/ { p++ } END { printf (\"%d\n\", p) }"
		;;

	courier)
		# Useful summary for courier processes
		echo "$PS" | awk "
			\$5 ~ /\/usr\/bin\/imapd/ { i++ }
			\$5 ~ /\/usr\/lib\/courier\/courier\/courierpop3d/ { p++ }
			END { printf (\"%d\n%d\n\", i, p) }"
		;;

	all)
		# Useful summary for all mail related processes
		# We substract 1 to i and f because the awk process itself match
		echo "$PS" | awk "
			/${INCOMING_PORT}/ { i++ }
			/${FILTERED_PORT}/ { f++ }
			\$5 ~ /\/usr\/bin\/imapd/ { j++ }
			\$5 ~ /\/usr\/lib\/courier\/courier\/courierpop3d/ { p++ }
			END { printf (\"%d\n%d\n%d\n%d\n\", i, f, j, p) }"
		;;

	*)
		# default: print help
		echo "Usage: snmpd-mail.sh incoming|filtered|smtpd|imapd|pop3d|courier|all"
		;;
esac

exit 0

