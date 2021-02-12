#!/bin/bash
node=$1
queue=$2
egroup=$3
iPort=$4
lPort=$5
# barFile=$6

# if [ $# -ne 6 ]; then 
if [ $# -ne 5 ]; then 
   echo "Invalid aurguments:"
#   echo "Usage: $0 <node> <queue> <executionGroup> <iPort> <lPort> <barFile>"
   echo "Usage: $0 <node> <queue> <executionGroup> <iPort> <lPort>"
   exit 1
fi

echo "$1 exported to /tmp/node.txt"
echo $1 >> /tmp/node.txt
echo "$2 exported to /tmp/queue.txt"
echo $2 >> /tmp/queue.txt

#sourcing mqsiprofile
source /opt/ibm/iib-10.0.0.15/server/bin/mqsiprofile

# Creating QM1 Queue Manager
crtmqm ${queue}

# Starting the QM1 Queue Manager
strmqm ${queue}

# Creating Integration Node with associate Queue Manager
mqsicreatebroker ${node} -q ${queue}
mqsichangeproperties ${node}  -b webadmin -o HTTPConnector -n port -v ${iPort}

# Starting the Integration Node
# creating Queues
runmqsc ${queue} << EOF
DEFINE QL(IN)
DEFINE QL(OUT)
define listener(listener.tcp) TRPTYPE(TCP) PORT(${lPort})
start listener(listener.tcp)
EOF

mqsistart ${node}

# Creating the Integration Server/ Execution Group
mqsicreateexecutiongroup ${node} -e ${egroup}

# Starting the message flow
mqsistartmsgflow ${node} -e ${egroup}

# Creating the Sample Configurable Service
mqsicreateconfigurableservice ${node} -c ActivityLog -o SampleConfigService -n filter,fileName,minSeverityLevel,formatEntries,executionGroupFilter,numberOfLogs,enabled,maxFileSizeMb,maxAgeMins -v "","","INFO","false","","4","true","25","0"
# Testing the bar files after succesffuly deployed you can RFHUtil tool or command line as below.
#Testing by putting message

#Putting the message on IN queue
/opt/mqm/samp/bin/amqsput IN ${queue} << EOF
Test1
Test2
EOF

#Getting the message from the OUT queue
/opt/mqm/samp/bin/amqsget OUT ${queue}

# *** MOVE TO ANSIBLE SCRIPT TO RUN FROM UCD *** Deploying the barfile into integration server on the Integration Node
# mqsideploy ${node} -e ${egroup} -a ${barFile} -m -w 600
