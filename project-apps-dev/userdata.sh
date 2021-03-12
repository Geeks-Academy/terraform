#!/bin/bash
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf

/sbin/sysctl -p

echo ECS_ENABLE_CONTAINER_METADATA=true >> /etc/ecs/ecs.config
echo ECS_CLUSTER=ProgrammersOnly >> /etc/ecs/ecs.config
service docker restart
start ecs

yum -y install aws-cli jq
yum update -y
yum install -y https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
yum install -y zabbix-agent vim

sed -i 's/Server=.*/Server=77.55.217.23/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/ServerActive=.*/ServerActive=77.55.217.23/' /etc/zabbix/zabbix_agentd.conf
curl http://169.254.169.254/latest/meta-data/public-ipv4 | xargs -I % sh -c "sed -i 's/Hostname=.*/Hostname=%/' /etc/zabbix/zabbix_agentd.conf" %
echo "HostMetadataItem=system.uname" >> /etc/zabbix/zabbix_agentd.conf

systemctl restart zabbix-agent

# echo "
# #!/bin/bash

# CONTAINER_IDS=\$(docker ps | awk '{if (NR!=1) {print \$1}}')
# TOPIC_ARN=\$(aws --region eu-central-1 sns list-topics | jq '.Topics' | jq '.[1].TopicArn' | tr -d \"\\\"\")

# echo \$CONTAINER_IDS

# for CONTAINER in \$CONTAINER_IDS
# do
#   IP=\$(docker inspect \$CONTAINER | jq '.[0].NetworkSettings.IPAddress' | tr -d \"\\\"\")
#   SERVICE_NAME=\$(docker inspect \$CONTAINER | jq '.[0].Config.Labels.\"com.amazonaws.ecs.container-name\"' | tr -d \"\\\"\")

#   if [ \$SERVICE_NAME == \"mongodb\" ]; then
#     echo \"MongoDB container ID: \$CONTAINER\"
#     aws --region eu-central-1 sns publish --topic-arn \$TOPIC_ARN --message \"create \$CONTAINER_NAME \$IP\"
#   fi
# done
# " > /mongo_discovery.sh

# chmod +x /mongo_discovery.sh

# crontab<<EOF
# 15 * * * * /mongo_discovery.sh
# EOF
