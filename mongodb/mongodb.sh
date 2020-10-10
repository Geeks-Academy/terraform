#!/bin/bash

export LOCAL_IP=`cat $(echo $ECS_CONTAINER_METADATA_FILE) | jq '.Networks' | jq '.[0].IPv4Addresses' | jq '.[0]' | tr -d "\""`
export CONTAINER_NAME=`cat $(echo $ECS_CONTAINER_METADATA_FILE) | jq '.ContainerName' | tr -d "\""`

aws --region eu-central-1 sns publish --topic-arn $TOPIC_ARN --message "create $CONTAINER_NAME $LOCAL_IP"

#Define cleanup procedure
cleanup() {
    echo "Container stopped, performing cleanup..."
    aws --region eu-central-1 sns publish --topic-arn $TOPIC_ARN --message "delete $CONTAINER_NAME $LOCAL_IP"
}

#Trap SIGTERM
trap 'true' SIGTERM

#Execute command
"${@}" &

#Wait
wait $!

#Cleanup
cleanup
