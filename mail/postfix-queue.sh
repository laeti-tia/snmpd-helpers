#! /bin/sh
# This script get some statistics about the current postfix mail queue
# It works with postfix v2 and above only
#
# The Postfix queues queried are active, deferred and incoming
# 
# You can either ask for (first arg)
# - requests		number of messages in the queue
# - kbytes		number of kbytes used by the queue
# - all			output of all values, one per line
#
# For this to work through snmpd, you need to add a sudo rule stating the snmpd user can run qshape and du:
#   snmp    ALL = (postfix) NOPASSWD: /usr/bin/du, /usr/sbin/qshape
#
# Copyright Antoine Delvaux 2002 - 2014

# Arguments to call the script
# $1 : information wanted (usuallly called with "all")

case "$1" in
  requests)
    sudo -u postfix qshape -s active deferred incoming | grep TOTAL | awk '{print $2}'
    ;;
  kbytes)
    sudo -u postfix du -ks /var/spool/postfix/active/ /var/spool/postfix/deferred/ /var/spool/postfix/incoming/ | awk 'BEGIN {total=0} {total += $1} END {print total}'
    ;;
  all)
    sudo -u postfix qshape -s active deferred incoming | grep TOTAL | awk '{print $2}'
    sudo -u postfix du -ks /var/spool/postfix/active/ /var/spool/postfix/deferred/ /var/spool/postfix/incoming/ | awk 'BEGIN {total=0} {total += $1} END {print total}'
    ;;
  *)
    echo "Usage: postfix-queue {requests|kbytes}"
    exit 1
esac

exit 0
