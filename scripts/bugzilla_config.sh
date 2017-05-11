#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

cd $BUGZILLA_ROOT

# Start database
/usr/bin/mysqld_safe &

# Wait for database
mysqladmin -h${BUGS_MYSQL_HOST} --silent --wait=30 ping || exit 1

# Configure database
mysql -u root -h ${BUGS_MYSQL_HOST} mysql -e "GRANT ALL PRIVILEGES ON *.* TO ${BUGS_MYSQL_USER}@localhost IDENTIFIED BY '${BUGS_MYSQL_PASSWORD}'; FLUSH PRIVILEGES;"
mysql -u root -h ${BUGS_MYSQL_HOST} mysql -e "CREATE DATABASE ${BUGS_MYSQL_DBNAME} CHARACTER SET = 'utf8';"

/usr/local/bin/cpanm --installdeps --quiet --notest .

perl checksetup.pl checksetup_answers.txt
perl checksetup.pl checksetup_answers.txt
perl scripts/generate_bmo_data.pl
generate_conduit_data.pl

# And stop
mysqladmin -u root shutdown
