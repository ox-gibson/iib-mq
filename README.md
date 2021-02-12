# iib-mq

Ansible files for installing and testing IIB and MQ

This is currently setup to run solely on ocpbaston01 and leverages ocpinfranode01, ocpinfranode02, and ocpsupport01
If you run this on another system, you will need to update the varHosts variable to match groups in the local ansible hosts file.

Here are the commands to run and the order:
1.	ansible-playbook provisionMqAndIntegrationBus.yaml -e varHosts=infranodes -e varMQVer=mqadv_dev912_linux_x86-64.tar.gz \
    -e varIIBVer=10.0.0.15-IIB.LINUX64-DEVELOPER.tar.gz
2.	ansible-playbook createNodeQueue.yaml -e varHosts=infranode2 -e node=IIB-Dev -e queue=QM01  -e eGroup=default  -e iPort=32769 -e lPort=32768
3.	ansible-playbook testHA.yaml -e varHosts=infranode1
    * - logs will be copied to /var/log/HA.log
4.	ansible-playbook cleanHA.yaml -e varHosts=infranode1
5.	ansible-playbook uninstall.yaml -e varHosts=infranodes

If you run into the can not remove user mqm, run the cleanHA.yaml