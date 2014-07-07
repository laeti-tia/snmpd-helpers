#!/bin/sh
# Prints out NFSd v4 stats for publication through snmpd
#
# © 2014 - Antoine Delvaux

NFS4STAT=`nfsstat -n -4 -s -l`
RPCSTAT=`nfsstat -r -s`

case "$1" in
	access-lookup)
		# All access and lookup operations
		echo "$NFS4STAT" | gawk '/(access|lookup|lookupp): / { s += $5 } END { printf("%d\n", s+0) }'
		;;
	
	attributes)
		# All attributes related operations
		echo "$NFS4STAT" | gawk '/(getattr|setattr): / { s += $5 } END { printf("%d\n", s+0) }'
		;;
	
	read)
		# All read related operations
		echo "$NFS4STAT" | gawk '/(read|readdir|readlink): / { s += $5 } END { printf("%d\n", s+0) }'
		;;
	
	write)
		# All write related operations
		echo "$NFS4STAT" | gawk '/(create|remove|rename|write): / { s += $5 } END { printf("%d\n", s+0) }'
		;;
	
	total-nfs4)
		# All NFS v4 requests
		echo "$NFS4STAT" | gawk '/total: / {print $5}'
		;;

	total-rpc)
		# All RPC requests
		echo "$RPCSTAT" | gawk '/^[0-9]+ / {print $1}'
		;;

	nfs4)
		# Useful summary for NFSv4
		echo "$NFS4STAT" | gawk '/total: / {print $5}'
		echo "$RPCSTAT" | gawk '/^[0-9]+ / {print $1}'
		echo "$NFS4STAT" | gawk '/(access|lookup|lookupp): / { s += $5 } END { printf("%d\n", s+0) }'
		echo "$NFS4STAT" | gawk '/(getattr|setattr): / { s += $5 } END { printf("%d\n", s+0) }'
		echo "$NFS4STAT" | gawk '/(read|readdir|readlink): / { s += $5 } END { printf("%d\n", s+0) }'
		echo "$NFS4STAT" | gawk '/(create|remove|rename|write): / { s += $5 } END { printf("%d\n", s+0) }'
		;;

	other)
		# Any other attributes, given as 2nd arg
		echo "$NFS4STAT" | gawk "/$2: / {print \$5}"
		;;

	*)
		# default: print help
		echo "Usage: snmpd-nfsd.sh access-lookup|attributes|read|write|total-nfs4|total-rpc|nfs4|other +anyop"
		;;
esac

exit 0

