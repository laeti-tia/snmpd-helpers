#!/usr/bin/perl
#
# This script prints out statistics about messages handled by postfix.
# The statistics are collected by the mailstatsdaemon.pl script
# running in the background and stored in a Berkeley DB file
#
# Copyright Antoine Delvaux 2002-2007
#

use DB_File;
my @counter_list = (
	'RECEIVED:local',
	'RECEIVED:smtp',
	'SENT:local',
	'SENT:virtual',
	'SENT:smtp',
	'BOUNCED:local',
	'BOUNCED:virtual',
	'BOUNCED:smtp',
	'BOUNCED:none',
	'REJECTED:local',
	'REJECTED:virtual',
	'REJECTED:smtp',
	'REJECTED:none',
	'PASSED:amavis',
	'INFECTED:amavis',
	'BLOCKEDSPAM:amavis'
	);
my $stats_file = '/tmp/stats.db' ;

tie(%foo, "DB_File", "$stats_file", O_RDONLY, 0666, $DB_HASH) || die ("Cannot open $stats_file");

if ($ARGV[0] eq "all") {
    foreach my $counter (@counter_list) {
	print (defined($foo{$counter}) ? $foo{$counter} : "0");
	print "\n";
    }
} elsif ($foo{$ARGV[0]}) {
    print "$foo{$ARGV[0]}\n";
} else {
    print "0\n";
}

untie %foo;
