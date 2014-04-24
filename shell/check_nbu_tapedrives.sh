#!/bin/sh
#
# check_nbu_tapedrives.sh
#
# Check status of tape drives in NetBackup
#
# Author: Andreas Lindh <andreas@superblock.se>
#
# Takes two arguments. Warning threshold and critical threshold.
#

RC=0
PROGNAME=`basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
. $PROGPATH/utils.sh

THRESHOLD_WARNING=$1
THRESHOLD_CRITICAL=$2

if [ $THRESHOLD_WARNING -gt $THRESHOLD_CRITICAL ]; then
    RC=$STATE_CRITICAL
    echo "ERROR: Warning threshold cannot be higher than critical threshold"
    exit $RC
fi

if [ $# -lt 2 ]; then
    echo "Usage: $0 <warning_threshold> <critical_treshold>"
    exit $STATE_UNKNOWN
fi


AWKBIN=$(which awk)
TPCONFIGBIN=/usr/openv/volmgr/bin/tpconfig

OUTPUT=`$TPCONFIGBIN -dl|$AWKBIN '/Status/ {print $2}'`

DRIVES_TOTAL=0
DRIVES_UP=0
DRIVES_DOWN=0

# Count ups and downs and totals
for DRIVE_STATUS in $OUTPUT; do
    DRIVES_TOTAL=$(($DRIVES_TOTAL+1))
    if [ $DRIVE_STATUS = "UP" ]; then
        DRIVES_UP=$(($DRIVES_UP+1))
    elif [ $DRIVE_STATUS == "DOWN" ]; then
        DRIVES_DOWN=$(($DRIVES_DOWN+1))
    fi
done

if [ $DRIVES_DOWN -eq 0 ]; then
    RC=$STATE_OK
    echo "OK: No drives are down"
elif [ $DRIVES_DOWN -gt $THRESHOLD_CRITICAL ]; then
    RC=$STATE_CRITICAL
    echo "CRITICAL: $DRIVES_DOWN drives are down"
elif [ $DRIVES_DOWN -gt $THRESHOLD_WARNING ]; then
    RC=$STATE_WARNING
    echo "WARNING: $DRIVES_DOWN drives are down"
fi

exit $RC
