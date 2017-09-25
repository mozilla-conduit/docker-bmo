#!/bin/bash -e
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

echo -e "\n== Starting database"
/usr/bin/mysqld_safe &
sleep 3

echo -e "\n== Starting memcached"
/usr/bin/memcached -u memcached -d

echo -e "\n== Starting push daemon"
su - $BUGZILLA_USER -c "cd $BUGZILLA_ROOT; perl ./extensions/Push/bin/bugzilla-pushd.pl start"

echo -e "\n== Starting web server"
/usr/sbin/httpd -DFOREGROUND -e info
