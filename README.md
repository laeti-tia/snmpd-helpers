snmpd-helpers
=============
This is a collection of scripts to publish host stats through [netsnmp][netsnmp].

Through years of system administration and monitoring various aspects of Linux and UNIX servers I have gathered some useful scripts to publish statistics through netsnmp.  Here is this collection for you to enjoy and, hopefully, contribute.

Usage
-----
Just distribute those scripts on the hosts you want to monitor and adapt your `snmpd.conf` file with snipets like this one:

    extend      .1.3.6.1.4.1.2021.999.1         apache          /usr/local/share/snmpd-helpers/apache/apache2-stats.pl all

Yes, I tend to put this git repository under `/usr/local/share/snmpd-helpers/`

See each script for details about the data collected and its usage.

Credits
-------
Many scripts come from previously existing source, see comments and credit in each one.

Credits also goes to [BELNET][belnet] and [Cassiopea][cassiopea] where I used, and still use, most of them during my work as system administrator.

Copyright and License
---------------------
© 2014 — Antoine Delvaux — All rights reserved.

See enclosed LICENSE file.

[netsnmp]: http://net-snmp.sourceforge.net
[belnet]: http://www.belnet.be
[cassiopea]: http://www.cassiopea.org
