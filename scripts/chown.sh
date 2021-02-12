#!/bin/bash

#Update Ownership on IIB Directories
echo "Updating Ownership and Permissions on /opt/ibm/"
chown -R iibuser:mqbrkrs /opt/ibm/
chmod -R 755 /opt/ibm/
echo "Updating Ownership and Permissions on /var/mqsi/"
chown -R iibuser:mqbrkrs /var/mqsi/
chmod -R 755 /var/mqsi/
echo *  hard    nofile  10250 >> /etc/security/limits.conf
echo *  soft    nofile  10250 >> /etc/security/limits.conf
cd ~; git clone https://github.com/chamilton614/iib-mq.git
cp /root/iib-mq/iib/iib-scripts/*.sh /usr/local/bin; cp /root/iib-mq/iib/iib-scripts/*.bar /usr/local/bin; chmod 777 /usr/local/bin/*.sh
cp /root/iib-mq/iib/iib-scripts/mq-config /etc/mqm/mq-config; chmod 777 /etc/mqm/mq-config
export BASH_ENV=/usr/local/bin/iib_env.sh; export AL_HOSTNAME=127.0.0.1; export LANG=en_US.UTF-8
iptables -I INPUT -p tcp --dport 4414 -j ACCEPT
iptables -I INPUT -p tcp --dport 4415 -j ACCEPT
iptables -I INPUT -p tcp --dport 4416 -j ACCEPT
iptables -I INPUT -p tcp --dport 7800 -j ACCEPT
iptables -I INPUT -p tcp --dport 1414 -j ACCEPT
iptables -I INPUT -p tcp --dport 1415 -j ACCEPT
iptables -I INPUT -p tcp --dport 1416 -j ACCEPT
iptables-save
echo 'source /opt/ibm/iib-10.0.0.15/server/bin/mqsiprofile' >> ~/.bash_profile
source ~/.bash_profile
