#!/bin/sh
# Prints out tmpfs partition usage for the given mount point
# Mount point should be doubled escaped, like:
#   snmpd-tmpfs.sh \\/dev\\/shm
/bin/df -t tmpfs -k | awk "/^tmpfs .* ${1}$/ {print \$2\"\n\"\$3}"
