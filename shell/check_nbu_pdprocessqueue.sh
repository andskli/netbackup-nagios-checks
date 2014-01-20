#!/bin/sh
#
# check_nbu_pdprocessqueue.sh
#
# Author: Andreas Lindh <andreas@innovationgroup.se>
#
# Check status of NetBackup PureDisk processqueue
# Takes two arguments. Warning threshold and critical treshold, in that
# specific order.
#

RC=0
PROGNAME=`basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
. $PROGPATH/utils.sh

THRESHOLD_WARNING=$1
THRESHOLD_CRITICAL=$2

AWKBIN=$(which awk)
CRCONTROLBIN=/usr/openv/pdde/pdcr/bin/crcontrol

if [ $THRESHOLD_WARNING -gt $THRESHOLD_CRITICAL ]; then
	echo "ERROR: Warning threshold cannot be higher than critical threshold"
	exit $STATE_UNKNOWN
fi

if [ $# -lt 2 ]; then
	echo "Usage: $0 <warning_threshold> <critical_threshold>"
	exit $STATE_UNKNOWN
fi

TOTALQUEUESIZE=`$CRCONTROLBIN --queueinfo | $AWKBIN '/total queue size/ {print $5}'`

if [ $TOTALQUEUESIZE -gt $THRESHOLD_CRITICAL ]; then
	echo "CRITICAL: Queue size critical size"
	RC=$STATE_CRITICAL
elif [ $TOTALQUEUESIZE -gt $THRESHOLD_WARNING ]; then
	echo "WARNING: Queue size at warning size"
	RC=$STATE_WARNING
else
	echo "OK: Queue size"
	RC=$STATE_OK
fi

exit $RC