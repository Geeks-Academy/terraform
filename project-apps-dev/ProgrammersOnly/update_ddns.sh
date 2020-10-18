#!/bin/bash

CONTAINER_IDS=`docker ps | awk '{if (NR!=1) {print $1}}'`

echo $CONTAINER_IDS

for CONTAINER in $CONTAINER_IDS
do
  IP=`docker inspect $CONTAINER | jq '.[0].NetworkSettings.IPAddress' | tr -d "\""`
  SERVICE_NAME=`docker inspect $CONTAINER | jq '.[0].Config.Labels."com.amazonaws.ecs.container-name"' | tr -d "\""`
  DOMAIN=`echo ".programmers.only"`

  if [ $SERVICE_NAME == null ]; then
    echo "Name not found for container: $CONTAINER"
  else
    echo `curl http://localhost:8080/update?secret=changeme\&domain=${SERVICE_NAME}\&addr=${IP}`
    if [ $? -eq "0" ]; then
      echo "$SERVICE_NAME $CONTAINER [OK]"
    fi
  fi
done
