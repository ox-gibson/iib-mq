#!/bin/bash

#sourcing mqsiprofile
source /opt/ibm/iib-10.0.0.15/server/bin/mqsiprofile

echo "######       Configuring files on gluster share       ######"       
share=/iibdata/
mkdir -p ${share}/QMHA/qmgrs
mkdir -p ${share}/QMHA/logs
chown -R mqm:mqm ${share}/QMHA
chmod -R ug+rwx ${share}/QMHA

echo "######       Queue Manager creation and config       ######"
echo "****** Creating queue manager QMHA on primary server ******"
crtmqm -ld ${share}/QMHA/logs -md ${share}/QMHA/qmgrs -q QMHA
echo "****** Sending dspmqinf to secondary server ******"
# Updating /var/mqm/mqs.ini
dspinfo=`dspmqinf -o command QMHA`
echo "SSHing $dspinfo to infranode02"
ssh root@ocpinfranode02 $dspinfo
echo " "
echo " "
echo "****** Displaying queue manager status ******"
dspmq -n -o standby -o status
echo " "
echo " "
echo "****** Starting ACTIVE queue manager QMHA on primary server ******"
strmqm -x QMHA
echo " "
echo " "
echo "****** Starting STANDBY queue manager QMHA ******"
ssh root@ocpinfranode02 strmqm -x QMHA
read -p "Check 02 with: dspmq -n -o standby -o status"
echo " "
echo " "
echo "****** Running runmqsc and adding objects ******"
runmqsc QMHA << EOF
define ql(source)
define ql(TARGET)
define chl(channel1) chltype(SVRCONN) trptype(tcp) MCAUSER('mqm')
define chl(channel1) chltype(clntconn) trptype(tcp)  conname('10.0.12.115(1414),10.0.12.116(1414)')  QMNAME(QMHA)
DEFINE CHANNEL('SYSTEM.ADMIN.SVRCONN') CHLTYPE(SVRCONN)
alter AUTHINFO(SYSTEM.DEFAULT.AUTHINFO.IDPWOS) AUTHTYPE(IDPWOS) CHCKCLNT(NONE)
ALTER QMGR CHLAUTH(DISABLED)
REFRESH SECURITY
define listener(listener.tcp) TRPTYPE(TCP) PORT(1414)
start listener(listener.tcp)
end
EOF
sleep 10
echo "######          Validating HA configuration           ######" > /var/log/HA.log
echo "Server 1" >> /var/log/HA.log
dspmq -n -o standby -o status >> /var/log/HA.log
echo "Server 2" >> /var/log/HA.log
ssh root@ocpinfranode02 dspmq -n -o standby -o status >> /var/log/HA.log
echo " " >> /var/log/HA.log
echo " " >> /var/log/HA.log
echo "****** Switching queue manager QMHA on primary server ******" >> /var/log/HA.log
endmqm -s QMHA >> /var/log/HA.log
sleep 5
echo "Server 1" >> /var/log/HA.log
dspmq -n -o standby -o status >> /var/log/HA.log
echo "Server 2" >> /var/log/HA.log
ssh root@ocpinfranode02 dspmq -n -o standby -o status >> /var/log/HA.log
echo " "
echo " "
echo "****** Starting STANDBY queue manager QMHA on primary server ******" >> /var/log/HA.log
strmqm -x QMHA >> /var/log/HA.log
sleep 5
echo "Server 1" >> /var/log/HA.log
dspmq -n -o standby -o status >> /var/log/HA.log
echo "Server 2" >> /var/log/HA.log
ssh root@ocpinfranode02 dspmq -n -o standby -o status >> /var/log/HA.log
echo " "
echo " "
echo "****** Switching queue manager QMHA on secondary server ******" >> /var/log/HA.log
ssh root@ocpinfranode02 "endmqm -s QMHA" >> /var/log/HA.log
sleep 5
echo "Server 1" >> /var/log/HA.log
dspmq -n -o standby -o status >> /var/log/HA.log
echo "Server 2" >> /var/log/HA.log
ssh root@ocpinfranode02 dspmq -n -o standby -o status >> /var/log/HA.log
echo " "
echo " "
echo "****** Starting STANDBY queue manager QMHA on secondary server ******" >> /var/log/HA.log
ssh root@ocpinfranode02 "strmqm -x QMHA" >> /var/log/HA.log
sleep 5
echo "Server 1" >> /var/log/HA.log
dspmq -n -o standby -o status >> /var/log/HA.log
echo "Server 2" >> /var/log/HA.log
ssh root@ocpinfranode02 dspmq -n -o standby -o status >> /var/log/HA.log
