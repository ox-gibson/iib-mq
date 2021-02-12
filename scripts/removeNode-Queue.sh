#!/bin/bash
source /opt/ibm/iib-10.0.0.15/server/bin/mqsiprofile
mqsilist
dspmq

while read node; do
   echo "stopping and deleting $node"
   mqsistop $node
   mqsideletebroker $node
done < /tmp/node.txt

while read queue; do
   echo "stopping and deleting $queue"
   endmqm $queue
   sleep 5
   for pid in `ps aux | grep -v "grep" | grep "${queue}" | awk '{print $2}'`
   do
      echo "Killing PID: $pid for $queue"
      kill -9 $pid
   done
   dltmqm $queue
done < /tmp/queue.txt

mqsilist
dspmq
rm -rf /tmp/*.txt
