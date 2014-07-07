#!/usr/bin/perl
######
# This script calculates current number of ftp users
#
# Copyright Antoine Delvaux 2002-2007
#

open(F, "/usr/local/bin/ftpcount |");
while(<F>) {
	if (/(\d+)\s+users/) {
		$users+=$1;
	}
}
print "$users\n";
