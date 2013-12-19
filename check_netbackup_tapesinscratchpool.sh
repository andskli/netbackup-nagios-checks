#!/bin/sh
#
# check_netbackup_tapesinscratchpool.sh
#
# Check tapes in scratch pool. Takes two arguments, first is warning
# threshold and second is critical threshold.
# Example
#   ./check_netbackup_tapesinscratchpool.sh 5 0
# Will warn when 5 tapes left and move to critical when zero tapes are
# left in scratch pool
#
# Author: Andreas Lindh <andreas@innovationgropu.se>
#

RC=0
PROGNAME=`basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
. $PROGPATH/utils.sh

THRESHOLD_WARNING=$1
THRESHOLD_CRITICAL=$2

if [ $THRESHOLD_CRITICAL -gt $THRESHOLD_WARNING ]; then
    RC=$STATE_UNKNOWN
    echo "ERROR: Warning value can't be lower than critical value"
    exit $RC
fi

if [ $# -gt 2 ]; then
    echo "Usage: $0 <warning_threshold> <critical_threshold>"
    exit $STATE_UNKNOWN
fi

AWKBIN=$(which awk)


