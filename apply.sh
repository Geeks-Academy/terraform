#!/bin/bash

git pull origin bartek
PPID1=$!
wait $PPID1

terraform apply -var-file="irland.tfvars"