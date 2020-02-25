#!/bin/bash

git pull origin bartek
PPID1=$!
wait $PPID1

terraform init -var-file="irland.tfvars"
PPID2=$!
wait $PPID2

terraform apply -var-file="irland.tfvars"
