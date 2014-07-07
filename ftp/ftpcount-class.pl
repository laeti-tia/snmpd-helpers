#!/usr/bin/perl
######
# This script calculates current number of ftp users in a specific class
#
# Copyright Antoine Delvaux 2002-2007
#

$class=$ARGV[0];
open(F, "/usr/local/bin/ftpcount |");
while(<F>) {
	if (/class $class\s+-\s+(\d+)\s+users/) {
		$users+=$1;
	}
}
print "$users\n";
