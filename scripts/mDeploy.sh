#!/bin/bash

#sourcing mqsiprofile
source /opt/ibm/iib-10.0.0.15/server/bin/mqsiprofile

# *** MOVE TO ANSIBLE SCRIPT TO RUN FROM UCD *** Deploying the barfile into integration server on the Integration Node
# mqsideploy VAR1  -e VAR2 -a /usr/local/bin/TestBar.bar -m -w 600
#mqsideploy IBNODE01 -e EG01 -a /usr/local/bin/TestBar.bar -m -w 600
mqsideploy $1 -e $2 -a $3 -m -w 600
