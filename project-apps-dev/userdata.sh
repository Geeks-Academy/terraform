#!/bin/bash
echo "export LOCAL_IP=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4`" >> /etc/profile

echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf

/sbin/sysctl -p

echo ECS_ENABLE_CONTAINER_METADATA=true >> /etc/ecs/ecs.config
echo ECS_CLUSTER=ProgrammersOnly >> /etc/ecs/ecs.config
service docker restart
start ecs

yum -y install aws-cli

cat > /mongo_discovery.sh  <<EOL
#!/bin/bash

CONTAINER_IDS=`echo "\`docker ps | awk '{if (NR!=1) {print \$1}}'\`"`
TOPIC_ARN=`echo "\$(aws --region eu-central-1 sns list-topics | jq '.Topics' | jq '.[1].TopicArn')"`

echo "\$CONTAINER_IDS"

for CONTAINER in "\$CONTAINER_IDS"
do
  IP=`echo "\`docker inspect $CONTAINER | jq '.[0].NetworkSettings.IPAddress' | tr -d \"\\\"\"\`"`
  SERVICE_NAME=`echo "\`docker inspect $CONTAINER | jq '.[0].Config.Labels."com.amazonaws.ecs.container-name"' | tr -d \"\\\"\"\`"

  if [ "\$SERVICE_NAME" == "mongodb" ]; then
    echo "MongoDB container ID: \$CONTAINER"
    aws --region eu-central-1 sns publish --topic-arn \$TOPIC_ARN --message "create \$CONTAINER_NAME \$IP"
  fi
done
EOL

chmod +x /mongo_discovery.sh

crontab<<EOF
15 * * * * /mongo_discovery.sh
EOF
