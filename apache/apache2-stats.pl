#!/usr/bin/perl
######
# This script calculates some apache live stats
# All the information is extracted from the server-status page of
# the running apache webserver.  So apache must be configured to use
# mod_status and this page should be available from the localhost
# through the use of the 'apache2ctl status' command (this means installing
# a www-browser package, the recommended one being lynx)
#
# Script could easily be adapted to access remotely to this page though.
#
# $APACHECTL should be configured to suit apache installation
#
# You can either ask for (first arg)
# - requests-sec	number of requests per second
# - bytes-sec		number of bytes per second
# - bytes-req		number of bytes per request
# - cpuload		CPU load
# - requests		number of concurrent requests
# - idle		number of idle apache processes
# - fcgid		number of running fcgid processes
# - all			output of all values, one per line
#
# History:
#	18/09/2012	Antoine Delvaux
#			- count running fcgid proceses
#	19/09/2005	Antoine Delvaux
#			- call 'apache2ctl fullstatus' to circumvent awk call
#	22/04/2005	Antoine Delvaux
#			- support for all values output in a single run
#	19/11/2003	Antoine Delvaux
#			- created
#

# apache2ctl tries to set 'ulimit -n 8192' which cannot work if not root
# This forces a bening ulimit call that will work for any user.
# See /etc/apache2/envvars
$ENV{APACHE_ULIMIT_MAX_FILES} = 'ulimit';
my $APACHECTL = '/usr/sbin/apache2ctl';
my $APACHESTATUS = $APACHECTL.' fullstatus';
my @val, $out, $outall;

if (-x $APACHECTL) {

    open(STATUS_OUT, "$APACHESTATUS|");

    while (<STATUS_OUT>) {

	if (($ARGV[0] eq "cpuload" || $ARGV[0] eq "all") && /CPU Usage/) {
		# grep the CPU load value
		@val = split (' ');
		if ($val[7]) {
			$out = $val[7];
		} else {
			# in case the % of CPU load cannot be computed because very low
			$out = 0;
		}
		$out =~ s/%//;
		$out =~ s/^\./0\./;
		$outall = $out;
	}

	if (($ARGV[0] eq "requests-sec" || $ARGV[0] eq "all") && /requests\/sec/) {
		# grep the number of requests per second
		@val = split (' ');
		$out = $val[0];
		$out =~ s/^\./0\./;
		$outall .= "\n".$out;
	}

	if (($ARGV[0] eq "bytes-sec" || $ARGV[0] eq "all") && /B\/second/) {
		# grep the number of bytes transmited per second
		@val = split (' ');
		if ($val[4] eq "kB/second") {
		    $out = $val[3] * 1000;
		} elsif ($val[4] eq "MB/second") {
		    $out = $val[3] * 1000000;
		} else {
		    $out = $val[3];
		}
		$out =~ s/^\./0\./;
		$outall .= "\n".$out;
	}

	if (($ARGV[0] eq "bytes-req" || $ARGV[0] eq "all") && /B\/request/) {
		# grep the number of bytes transmited per request
		@val = split (' ');
		if ($val[7] eq "kB/request") {
		    $out = $val[6] * 1000;
		} elsif ($val[7] eq "MB/request") {
		    $out = $val[6] * 1000000;
		} else {
		    $out = $val[6];
		}
		$out =~ s/^\./0\./;
		$outall .= "\n".$out;
	}

	if (($ARGV[0] eq "requests" || $ARGV[0] eq "all") && /requests currently/) {
		# grep the number of concurent requests
		@val = split (' ');
		$out = $val[0];
		$outall .= "\n".$out;
	}

	if (($ARGV[0] eq "idle" || $ARGV[0] eq "all") && /requests currently/) {
		# grep the number of concurent requests
		@val = split (' ');
		$out = $val[5];
		$outall .= "\n".$out;
	}

	if (($ARGV[0] eq "fcgid" || $ARGV[0] eq "all") && /Total FastCGI processes/) {
		# grep the number of running FastCGI processes
		@val = split (':');
		$out = $val[1];
		$out =~ s/^\s+|\s+$//g; # remove white spaces
		$outall .= "\n".$out;
	}
    }

    close(STATUS_OUT);

    if ($out && $ARGV[0] ne "all" ) {
        print $out."\n";
    } elsif ($outall) {
        print $outall."\n";
    } else {
	print "No value found in the output of apache2ctl !\n";
	print "Usage: $0 cpuload|requests-sec|bytes-sec|bytes-req|requests|idle|fcgid|all\n";
    }

} else {
    print "apache2ctl command not found !\n";
}

