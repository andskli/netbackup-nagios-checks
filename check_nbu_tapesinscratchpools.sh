#!/bin/sh
#
# check_nbu_tapesinscratchpool.sh
#
# Check tapes in scratch pool. Takes two arguments, first is warning
# threshold and second is critical threshold.
# Example
#   ./check_nbu_tapesinscratchpool.sh 5 0
# Will warn when 5 tapes left and move to critical when zero tapes are
# left in scratch pool
#
# Author: Andreas Lindh <andreas@innovationgroup.se>
#

RC=0
PROGNAME=`basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
. $PROGPATH/utils.sh

THRESHOLD_WARNING=$1
THRESHOLD_CRITICAL=$2

AWKBIN=$(which awk)
VMPOOLBIN=/usr/openv/volmgr/bin/vmpool
VMQUERYBIN=/usr/openv/volmgr/bin/vmquery

MASTERSERVER=`uname -n`
SCRATCH_COUNT=0

if [ $THRESHOLD_CRITICAL -gt $THRESHOLD_WARNING ]; then
    RC=$STATE_UNKNOWN
    echo "ERROR: Warning value can't be lower than critical value"
    exit $RC
fi

if [ $# -lt 2 ]; then
    echo "Usage: $0 <warning_threshold> <critical_threshold>"
    exit $STATE_UNKNOWN
fi

SCRATCH_POOLS=`$VMPOOLBIN -list_scratch|$AWKBIN '!/(^Scratch Pools$|^============.*$)/'`
set $SCRATCH_POOLS
if [ $# -lt 1 ]; then
    echo "UNKNOWN: No scratch pools found"
    exit $STATE_UNKNOWN
fi

# Summarize number of scratch tapes
for pool in $SCRATCH_POOLS; do
    count=$(expr `$VMQUERYBIN -h $MASTERSERVER -pn $pool -b|wc -l` - 3)
    SCRATCH_COUNT=$(($SCRATCH_COUNT+$count))
done

if [ $SCRATCH_COUNT -lt $THRESHOLD_WARNING ]; then
    RC=$STATE_WARNING
    echo "WARNING: Only $SCRATCH_COUNT scratch tapes left"
elif [ $SCRATCH_COUNT -lt $THRESHOLD_CRITICAL ]; then
    RC=$STATE_CRITICAL
    echo "CRITICAL: NO scratch tapes left"
else
    RC=$STATE_OK
    echo "OK: $SCRATCH_COUNT scratch tapes left"
fi

exit $RC