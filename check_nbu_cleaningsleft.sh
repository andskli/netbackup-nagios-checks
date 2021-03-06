#!/bin/sh
#
# check_nbu_cleaningsleft.sh
#
# Find all netbackup tapes with CLN* barcode, if any with zero cleanings left
# are found, exit with a warning, if all tapes found all have zero cleanings left
# exit with critical state.
#
# Author: Andreas Lindh <andreas@superblock.se>
#

RC=0
PROGNAME=`basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
. $PROGPATH/utils.sh

MASTERSERVER=`uname -n`

AWKBIN=$(which awk)
VMQUERYBIN=/usr/openv/volmgr/bin/vmquery

CLEANING_TAPES=`$VMQUERYBIN -h $MASTERSERVER -b -a|$AWKBIN '/^CLN*/ {print $1}'`
FINISHED_CLEANING_TAPES=""

for tape in $CLEANING_TAPES; do
    CLEANINGS_LEFT=`$VMQUERYBIN -m $tape|$AWKBIN '/^cleanings left/ {print $3}'`
    if [ $CLEANINGS_LEFT -eq 0 ]; then
        RC=$STATE_WARNING
        FINISHED_CLEANING_TAPES="${FINISHED_CLEANING_TAPES} $tape"
    fi
done

NUM_CLEANING_TAPES=`echo $CLEANING_TAPES|wc -w`
NUM_FINISHED_CLEANING_TAPES=`echo $FINISHED_CLEANING_TAPES|wc -w`
if [ $NUM_CLEANING_TAPES -eq $NUM_FINISHED_CLEANING_TAPES ]; then
    echo "CRITICAL: All cleaning tapes have zero cleanings left"
    RC=$STATE_CRITICAL
elif [ $NUM_FINISHED_CLEANING_TAPES -gt 1 ]; then
    echo "WARNING: No cleanings left on $FINISHED_CLEANING_TAPES"
    RC=$STATE_WARNING
else
    echo "OK: Cleaning tapes have cleanings left"
    RC=$STATE_OK
fi

exit $RC
