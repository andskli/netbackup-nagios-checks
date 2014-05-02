#!/bin/sh
#
# check_nbu_pdstatus.sh
#
# Author: Andreas Lindh <andreas@superblock.se>
#
# Check status of NetBackup PureDisk. Make sure GET/PUT is OK.
#

PROGNAME=`basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
. $PROGPATH/utils.sh
RC=0

AWKBIN=$(which awk)
CRCONTROLBIN=/usr/openv/pdde/pdcr/bin/crcontrol

CRCONTROLSTATUSES=`$CRCONTROLBIN --getmode | $AWKBIN '{print $3" "$4}'`

for s in $CRCONTROLSTATUSES; do
	getorput=$(echo $s|$AWKBIN -F'=' '{print $1}')
	yesorno=$(echo $s|$AWKBIN -F'=' '{print $2}')
	if [ "${yesorno}" == "No" ]; then
		echo "CRITICAL: $getorput is in No state"
		RC=$STATE_CRITICAL
	fi
done

exit $RC
