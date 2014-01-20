#!/bin/sh
#
# check_nbu_pdstatus.sh
#
# Author: Andreas Lindh <andreas@innovationgroup.se>
#
# Check status of NetBackup PureDisk. Make sure GET/PUT is OK.
#

RC=0
PROGNAME=`basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
. $PROGPATH/utils.sh

THRESHOLD_WARNING=$1
THRESHOLD_CRITICAL=$2

AWKBIN=$(which awk)
CRCONTROLBIN=/usr/openv/pdde/pdcr/bin/crcontrol

CRCONTROLSTATUSES=`$CRCONTROLBIN --getmode | $AWKBIN '{print $3" "$4}'`

for s in $CRCONTROLSTATUSES; do
	getorput=$(echo $s|$AWKBIN -F'=' '{print $1}')
	yesorno=$(echo $s|$AWKBIN -F'=' '{print $2}')
	if [ "No" -eq "$yesorno" ]; then
		echo "CRITICAL: $getorput is in No state"
		RC=$STATE_CRITICAL
	fi
done

exit $RC