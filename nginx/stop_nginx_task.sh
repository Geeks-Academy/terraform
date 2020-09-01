#!/bin/bash

tasks=`aws ecs list-tasks --cluster ProgrammersOnly | jq '.taskArns'`

for task in $tasks; do
    name=""
    if [ ${#task} -gt 1 ]; then
        task=`echo $task | tr -d '\"'`
        name=`aws ecs describe-tasks --cluster ProgrammersOnly --tasks $task | jq '.tasks' | jq '.[0].overrides.containerOverrides' | jq '.[0].name' | tr -d '\"'`
        if [[ $name == "nginx" ]]; then
            echo $name
            aws ecs stop-task --cluster ProgrammersOnly --task $task
        fi
    fi
done
