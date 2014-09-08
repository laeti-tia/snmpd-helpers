#!/usr/bin/perl -w
# reports the ntp synchronisation parameters:
# - offset (in seconds)
#       if positive it is returned as the first value
#       if negative its absolute value is returned as the second value
# - frequency error (in part per million, or ppm)
#       if positive it is returned as the first value
#       if negative its absolute value is returned as the second value
# - wander, or variation of clock frequency, or stability (in ppm)
# - jitter also called clock jitter (in seconds)
# - noise also called system jitter (in seconds)

use strict;
my ($offset, $frequency, $wander, $jitter, $noise);

# We query the local ntpd
my $NTPQ = '/usr/bin/ntpq -c rv';

open(NTPQ_OUT, "$NTPQ |");
while(<NTPQ_OUT>) {
    if (/offset=([0-9.-]+)/) {
        # We report the offset in seconds
        $offset = (( $1 / 1000 )); 
    }
    if (/, frequency=([0-9.-]+)/) {
        $frequency = $1;
    }
    if (/clk_wander=([0-9.-]+)/ || /stability=([0-9.-]+)/) {
        $wander = $1;
    }
    if (/clk_jitter=([0-9.-]+)/ || /, jitter=([0-9.-]+)/) {
        # We report the jitter in seconds
        $jitter = (( $1 / 1000 ));
    }
    if (/sys_jitter=([0-9.-]+)/ || /, noise=([0-9.-]+)/) {
        # We report the jitter in seconds
        $noise = (( $1 / 1000 ));
    }
}
close(NTPQ_OUT);

## Print the collected stats
# Offset is reported on 2 different lines depending if it is positive of negative.
if ($offset >= 0) {
    print $offset."\n0\n";
} else {
    print "0\n".-$offset."\n";
}
if ($frequency >= 0) {
    print $frequency."\n0\n";
} else {
    print "0\n".-$frequency."\n";
}
print $wander."\n";
print $jitter."\n";
print $noise."\n";

