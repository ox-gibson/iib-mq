#!/bin/bash

#sourcing mqsiprofile
source /opt/ibm/iib-10.0.0.15/server/bin/mqsiprofile

# Cleaning up previous run
if dspmq | grep QMHA ; then
   endmqm QMHA
   sleep 5
   for pid in `ps aux | grep -v "grep" | grep "QMHA" | awk '{print $2}'`
   do
      echo "Killing PID: $pid for QMHA"
      kill -9 $pid
   done
   ssh ocpinfranode02 rmvmqinf QMHA
   #ssh ocpinfranode02 endmqm QMHA
   #sleep 5
   dltmqm QMHA
   sleep 5
   #ssh ocpinfranode02 dltmqm QMHA
   #sleep 5
   rm -rf /iibdata/QMHA
fi
