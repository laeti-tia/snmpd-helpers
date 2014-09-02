#!/usr/bin/perl
# Follow the ntp synchronisation offset
# If the offset is positive it is returned as the first value
# If the offset is negative its absolute value is returned as the second value

# We query the local ntpd
my $NTPQ = '/usr/bin/ntpq -c rv';

open(NTPQ_OUT, "$NTPQ |");
while(<NTPQ_OUT>) {
    /offset=([0-9.-]+), / or next;
    # We report the offset in seconds
    my $offset = (( $1 / 1000 )); 
    if ($offset >= 0) {
        print $offset."\n0\n";
    } else {
        print "0\n".-$offset."\n";
    }
}
close(NTPQ_OUT);
