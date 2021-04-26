#!/bin/bash
# echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
# echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf

# /sbin/sysctl -p

# yum -y install aws-cli jq
# yum update -y
# yum install -y https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
# yum install -y zabbix-agent vim

# sed -i 's/Server=.*/Server=77.55.217.23/' /etc/zabbix/zabbix_agentd.conf
# sed -i 's/ServerActive=.*/ServerActive=77.55.217.23/' /etc/zabbix/zabbix_agentd.conf
# curl http://169.254.169.254/latest/meta-data/public-ipv4 | xargs -I % sh -c "sed -i 's/Hostname=.*/Hostname=%/' /etc/zabbix/zabbix_agentd.conf" %
# echo "HostMetadataItem=system.uname" >> /etc/zabbix/zabbix_agentd.conf

# systemctl restart zabbix-agent
